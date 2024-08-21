// build typescript with bun
const entry = App.configDir + "/main.ts";
const outdir = "/tmp/ags/js";

try {
  await Utils.execAsync([
    "bun",
    "build",
    entry,
    "--outdir",
    outdir,
    "--external",
    "resource://*",
    "--external",
    "gi://*",
  ]);
  await import(`file://${outdir}/main.js`);
} catch (error) {
  console.error(error);
}

Utils.monitorFile(
  // directory that contains the scss files
  `${App.configDir}`,

  function () {
    App.resetCss();
    App.applyCss(`${App.configDir}/main.css`);
  },
  // // reload function
  // function () {
  //   // main scss file
  //   const scss = `${App.configDir}/main.scss`;
  //
  //   // target css file
  //   const css = `/tmp/ags/main.css`;
  //
  //   // compile, reset, apply
  //   Utils.exec(`sassc ${scss} ${css}`);
  //   App.resetCss();
  //   App.applyCss(css);
  // },
);

export {};
