const { exec } = require('child_process');

const command = 'au3.exe C:\\_o\\__\\os-desk-browsers\\desk-browsers.au3';

exec(command, (error, stdout, stderr) => {
    if (error) {
        console.error(`Execution Error: ${error.message}`);
        process.exit(1);
    }
    if (stderr) {
        console.error(`stderr: ${stderr}`);
    }
    if (stdout) {
        console.log(`stdout: ${stdout}`);
    }
});
