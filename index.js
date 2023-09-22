const puppeteer = require("puppeteer");

function sleep(time) {
  return new Promise((res, rej) => {
    setTimeout(res, time);
  });
}

(async () => {
  console.log("asdasd");
  const browser = await puppeteer.launch({ headless: false });
  const upperLimit = 30;
  let count = 0;
  while (true) {
    if (count < upperLimit) {
      let context = await browser.createIncognitoBrowserContext();
      let page = await context.newPage();

      await page.goto(
        "https://spectra.queue-it.net/?c=spectra&e=ucla20230922&t=https%3A%2F%2Fucla.evenue.net%2Fsignin%3Fui%3DSH%26continue%3Dhttps%253A%252F%252Fucla.evenue.net%252Fcgi-bin%252Fncommerce3%252FSEGetGroupList%253FgroupCode%253DGS-MULTI%2526linkID%253Ducla-multi%2526shopperContext%253D%2526caller%253D%2526appCode%253D%2526addrReq%253D%2526phoneReq%253D%2526RSRC%253D%2526RDAT%253D%2526linkSource%253D%2526shopperContext%253D"
      );
      await page.bringToFront();
      count += 1;
    } else {
      await sleep(3000);
    }
  }
})();
