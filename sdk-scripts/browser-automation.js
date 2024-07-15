const fs = require('fs');
const { chromium } = require('playwright');

// Set Lab URI before runnng the scripts,
const labURI = ''; // example => "/games/5156/labs/33678"

const runner = async () => {
  const browser = await chromium.connectOverCDP('http://localhost:9222');
  const defaultContext = browser.contexts()[0];
  defaultContext.setDefaultTimeout(1000 * 60 * 10); // 10 minutes

  const getPage = (urlRegex) => {
    const pages = defaultContext.pages();
    const filter = (page) => new RegExp(urlRegex).test(page.url());
    const selected = pages.find(filter);
    return selected;
  };
  const labPage = getPage(labURI);

  // Waiting for Resources
  const waitForResources = async () => {
    const resources = await labPage.waitForResponse(/focuses\/show/);
    const data = await resources.json();
    const { resourceData, labInstanceId, labDetails } = data;
    const { provisioning, labControlButton, assessmentInfo } = data;
    const isResourceReady = !provisioning && labControlButton.running;
    if (!isResourceReady) return waitForResources();
    return { resourceData, labInstanceId, labDetails, assessmentInfo };
  };
  const { resourceData, labInstanceId, labDetails, assessmentInfo } = await waitForResources();

  /**
   * Store Resource Variables
   * Need to change depends on the labs requirements
   */
  storeVariables(
    [
      // The requirement variables of the lab!
      // find the available on VARIABLES.md or remove this if the lab doesn't need variables
    ],
    resourceData,
  );

  // get Login Credentials
  const { value: username } = labDetails.find(({ property }) => property === 'username');
  const { value: password } = labDetails.find(({ property }) => property === 'password');

  // Console Login
  const waitForLoginPage = () => {
    return new Promise((resolve, reject) => {
      const loginURI = /v3\/signin\/identifier/;
      const loginPage = getPage(loginURI);
      if (loginPage) return resolve(loginPage);

      const cp = setInterval(() => {
        const loginPage = getPage(loginURI);
        if (!loginPage) return;
        clearInterval(cp);
        return resolve(loginPage);
      }, 2000);
    });
  };

  const consolePage = await waitForLoginPage();
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

  // // Continue
  const contBTN = consolePage.locator('button', { hasText: 'Continue' });
  await contBTN.waitFor();
  await contBTN.click();

  // Allow
  const allowBtn = consolePage.locator('button', { hasText: 'Allow' });
  await allowBtn.waitFor();
  await allowBtn.click();

  // Accept Terms and Condition
  const termsPage = await defaultContext.newPage();
  await termsPage.goto('https://console.cloud.google.com/terms/cloud?pli=1&authuser=1&hl=en');
  const wrapper = termsPage.locator('cfc-virtual-viewport');
  const pageTxt = await wrapper.textContent();
  if (/Click the button below/.test(pageTxt)) {
    const acceptBtn = termsPage.locator('cfc-progress-button button');
    await acceptBtn.click();
  }

  // lab Progress Checker
  // Please consider to change delay, because it would send request to the server relentlessly once its run
  await delayed(5); // in seconds
  await labPage.evaluate(labProgressChecker, {
    labID: labInstanceId,
    progress: assessmentInfo,
  });

  browser.close();
};

runner();

/**
 * Funtion To Store dynamic Variables from Lab into Environtment Variables
 */
const storeVariables = (varList = [], resourceData) => {
  const variables = varList.map(({ var: str = '', prop = '' }) => {
    const findVal = `.${prop}`.split('.').reduce((pv, curr, i) => {
      const obj = pv || resourceData || {};
      const currentVal = obj[curr];
      return currentVal;
    });
    return `${str}=${findVal}`;
  });
  const varResult = variables.join('\n') + '\n';

  // Write Variables to File
  fs.writeFile('variables.txt', varResult, 'utf-8', (err) => {
    if (!err) return;
    console.log(err);
    throw err;
  });
};

/**
 * Function for automatically Check and End Lab, Running in Browser Instance not in playwright/NodeJS Environtment
 */
const labProgressChecker = async ({ labID, progress }) => {
  const checkLab = async () => {
    let assessmentInfo = progress || [];
    console.log('%cVerifying..', 'color:#00aaff;');
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
    const t = setTimeout(() => {
      resolve('ok');
      clearTimeout(t);
    }, time * 1000);
  });
};

