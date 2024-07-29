/** ========================================================================================================
 *  ----------------------------------- EDIT THE VARIABLES BELOW -------------------------------------------
 *  ------------ PLEASE ENSURE to SET THE LAB URI and VARIABLES before running the scripts!!! --------------
 *  ======================================================================================================== */

const labURI = ''; // example => "https://cloudskillsboost.google/games/5156/labs/33678"
const delayBeforeCheckLab = 15; // in seconds
const browserPORT = 9222; // Your Browser Debugging Port
const variables = [
    // NEEDS TO BE CHANGED depending on the lab's requirements.
    // Find the required variable in VARIABLES.md or leave this array blank if the lab doesn't need one.
];

/** =================================== END OF REQUIRED VARIABLES ========================================== */

const fs = require('fs');
const { chromium } = require('playwright');

// BROWSER RUNNER
let browserInstance = {};
const runner = async () => {
    const browser = await browserContext();
    const labPage = await waitForPage(browser, labURI);
    const labResources = await waitForResources(labPage);
    const { resourceData, labInstanceId, labDetails, assessmentInfo } = labResources;
    storeVariables(resourceData, variables);

    // get Login Credentials
    const { value: username } = labDetails.find(({ property }) => property === 'username');
    const { value: password } = labDetails.find(({ property }) => property === 'password');

    // Console Login
    await consoleLogin({ browser, username, password });
    await acceptTOS(browser); // required for enabling Google Cloud API Library

    // Check Progress
    await delayed(delayBeforeCheckLab);
    await labPage.evaluate(labProgressChecker, {
        labID: labInstanceId,
        progress: assessmentInfo,
    });

    // Close browser Connection
    browserInstance.close();
};

// Connect to the browser you used to log in to the GCSB.
const browserContext = async () => {
    browserInstance = await chromium.connectOverCDP('http://localhost:' + browserPORT);
    const defaultContext = browserInstance.contexts()[0];
    defaultContext.setDefaultTimeout(1000 * 60 * 10); // 10 minutes
    return defaultContext;
};

// Find a specific page by URL
const getPage = (browser, urlRegexp) => {
    const pages = browser.pages();
    const filter = (page) => new RegExp(urlRegexp).test(page.url());
    const selected = pages.find(filter);
    return selected;
};

const waitForPage = (browser, uri) => {
    return new Promise((resolve, reject) => {
        const pageReady = getPage(browser, uri);
        if (pageReady) return resolve(pageReady);

        const timeout = setInterval(() => {
            const page = getPage(browser, uri);
            if (!page) return;
            clearInterval(timeout);
            return resolve(page);
        }, 2000);
    });
};

// Waiting for Lab Resources
const waitForResources = async (labPage) => {
    const resources = await labPage.waitForResponse(/focuses\/show/);
    const data = await resources.json();
    const { resourceData, labInstanceId, labDetails } = data;
    const { provisioning, labControlButton, assessmentInfo } = data;
    const isResourceReady = !provisioning && labControlButton.running;
    if (!isResourceReady) return waitForResources();
    return { resourceData, labInstanceId, labDetails, assessmentInfo };
};

// Login into console and connect with GCloud SDK
const consoleLogin = async ({ browser, username, password }) => {
    const consolePage = await waitForPage(browser, /v3\/signin\/identifier/);
    const authKeyMode = /authcode.html/.test(consolePage.url());

    const emailField = consolePage.locator('input[type=email]');
    await emailField.waitFor();
    await emailField.fill(username);
    await consolePage.locator('#identifierNext button[type=button]').click();

    const passwordField = consolePage.locator('#password input');
    await passwordField.waitFor();
    await passwordField.fill(password);
    await consolePage.locator('#passwordNext button[type=button]').click();
    await consolePage.waitForEvent('load');

    // I Understand
    if (!/signin\/oauth\/id/.test(consolePage.url())) {
        const uBtn = consolePage.locator('#confirm');
        await uBtn.waitFor();
        await uBtn.click();
    }

    // Continue
    const contBTN = consolePage.locator('button', { hasText: 'Continue' });
    await contBTN.waitFor();
    await contBTN.click();

    // Allow
    const allowBtn = consolePage.locator('button', { hasText: 'Allow' });
    await allowBtn.waitFor();
    await allowBtn.click();

    if (!authKeyMode) return;
    const codeBlock = consolePage.locator('code.auth-code');
    const authCode = await codeBlock.innerText();
    writeFile('tmp/login_key.txt', authCode);
};

// Accept Terms and Condition
const acceptTOS = async (browser) => {
    const termsPage = await browser.newPage();
    await termsPage.goto('https://console.cloud.google.com/terms/cloud?pli=1&authuser=1&hl=en');
    const wrapper = termsPage.locator('cfc-virtual-viewport');
    const pageTxt = await wrapper.textContent();
    if (/Click the button below/.test(pageTxt)) {
        const acceptBtn = termsPage.locator('cfc-progress-button button');
        await acceptBtn.click();
    }
};

// Store dynamic variables from the lab into environment variables.
const storeVariables = (resourceData, varList = []) => {
    // Storing Project ID
    const { project_id } = resourceData.project_0;
    writeFile('tmp/project_id.txt', project_id + '\n');

    // Storing Lab Variables
    const variables = varList.map(({ var: str = '', prop = '' }) => {
        const findVal = `.${prop}`.split('.').reduce((pv, curr, i) => {
            const obj = pv || resourceData || {};
            const currentVal = obj[curr];
            return currentVal;
        });
        return `${str}=${findVal}`;
    });
    const project = `PROJECT_ID=${project_id}`;
    const varResult = [project, ...variables].join('\n') + '\n';
    writeFile('tmp/variables.txt', varResult);
};

const writeFile = (filePath, content) => {
    fs.writeFile(filePath, content, 'utf-8', (err) => {
        if (!err) return;
        console.log(err);
        throw err;
    });
};

const clearTMPFiles = () => {
    const tmpFiles = ['project_id', 'login_key', 'variables'];
    tmpFiles.forEach((f) => writeFile('tmp/' + f + '.txt', ''));
};

// Automatically check and end the lab, running in a browser instance rather than in a playwright/NodeJS environment.
const labProgressChecker = async ({ labID, progress }) => {
    const checkLab = async () => {
        let assessmentInfo = progress || [];
        console.log('%cChecking Progress..', 'color:#00aaff;');
        const { step_complete = [] } = assessmentInfo;

        const steps = step_complete.map(async (isComplete, i) => {
            if (isComplete) return checkUI(i);
            const justComplete = await checkStep(labID, i + 1);
            if (justComplete) checkUI(i);
            return justComplete;
        });

        const checkResult = await Promise.all(steps);
        assessmentInfo = { step_complete: checkResult };
        if (checkResult.includes(false)) return checkLab();
        endLab();
    };

    const checkStep = async (labInstanceId, step = 1) => {
        const gcsb = 'https://www.cloudskillsboost.google';
        const stepURL = `${gcsb}/assessments/run_step.json?id=${labInstanceId}&step=${step}&u=${Math.random()}`;
        const data = await fetch(stepURL);
        const { step_complete } = await data.json();
        const isComplete = step_complete[step - 1];
        return isComplete;
    };

    // Checklis Progress
    const trackerPanel = document.querySelectorAll('ql-activity-tracking');
    const checkUI = (i) => {
        const checkButton = trackerPanel[i].shadowRoot.querySelector('ql-button');
        const btn = checkButton.shadowRoot.querySelector('button');
        if (btn.disabled) return true;
        btn.click();
        return true;
    };

    const endLab = async () => {
        const finalize = document.querySelector('#js-are-you-sure-button');
        const finalizeButton = finalize.shadowRoot.querySelector('button');
        finalizeButton.click();
    };

    return checkLab();
};

// delay promise
const delayed = (time) => {
    return new Promise((resolve, reject) => {
        if (isNaN(time) || time < 1) return resolve('ok');
        const t = setTimeout(() => {
            resolve('ok');
            clearTimeout(t);
        }, time * 1000);
    });
};

clearTMPFiles();
runner();
