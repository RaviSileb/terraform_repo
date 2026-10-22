// Vyrenderuje HTML slidy do PNG. Použití: node slidy.js seznam.json
// seznam.json = [{"html": "/abs/cesta.html", "png": "/abs/cesta.png"}, ...]
const fs = require('fs');
const path = require('path');
let playwright;
try { playwright = require('playwright'); } catch { playwright = require(path.join(process.env.PLAYWRIGHT_MODULE || '/opt/node22/lib/node_modules/playwright')); }
(async () => {
  const seznam = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
  const browser = await playwright.chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1280, height: 720 } });
  for (const s of seznam) {
    await page.goto('file://' + s.html);
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: s.png });
  }
  await browser.close();
})();
