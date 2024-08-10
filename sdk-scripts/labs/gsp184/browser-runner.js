const { chromium } = require('playwright');

// BROWSER RUNNER
const runner = async () => {
    const executablePath = 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
    const browserInstance = await chromium.launch({ executablePath });
    const browser = await browserInstance.newContext();
    browser.setDefaultTimeout(1000 * 60 * 3); // 3 minutes

    const page = await browser.newPage();
    await waitForPage(page, 'http://localhost:8888');

    const qbtn = page.locator('#question a');
    await qbtn.click();

    const author = page.locator('#author');
    await author.fill('Your Name');

    const quiz = page.locator('#quiz');
    await quiz.selectOption('Google Cloud Platform');

    const title = page.locator('#title');
    await title.fill('Which company owns Google Cloud?');

    const answer1 = page.locator('#answer1');
    await answer1.fill('Amazon');

    const answer2 = page.locator('#answer2');
    await answer2.fill('Google');

    const fg = page.locator('.form-group', { hasText: 'Answer 2' });
    const radio = fg.locator('input[type=radio]');
    await radio.check();

    const answer3 = page.locator('#answer3');
    await answer3.fill('IBM');

    const answer4 = page.locator('#answer4');
    await answer4.fill('Microsoft');

    const submit = page.locator('button[type=submit]');
    await submit.click();

    browserInstance.close();
};

const waitForPage = async (page, url) => {
    try {
        await page.goto(url);
        return page;
    } catch (e) {
        console.log('waiting Page');
        return waitForPage(page, url);
    }
};

runner();
