const puppeteer = require("puppeteer");
const yargs = require("yargs");

function sleep(time) {
  return new Promise((res) => setTimeout(res, time));
}

async function runBrowser(url, upperLimit) {
  console.log("Starting browser...");
  const browser = await puppeteer.launch({ headless: false });
  let count = 0;

  while (true) {
    if (count < upperLimit) {
      let context = await browser.createBrowserContext();
      let page = await context.newPage();
      await page.goto(url);
      await page.bringToFront();
      count += 1;
      console.log(`Opened page ${count} of ${upperLimit}`);
    } else {
      await sleep(3000);
    }
  }
}

yargs
  .command(
    "$0 <url>",
    "Open multiple incognito browser windows",
    (yargs) => {
      yargs
        .positional("url", {
          describe: "URL to open in browser windows",
          type: "string",
        })
        .option("limit", {
          alias: "l",
          describe: "Upper limit of browser windows",
          type: "number",
          default: 30,
        });
    },
    async (argv) => {
      try {
        await runBrowser(argv.url, argv.limit);
      } catch (error) {
        console.error("An error occurred:", error);
        process.exit(1);
      }
    }
  )
  .help().argv;
