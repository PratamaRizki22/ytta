# SDK SCRIPT RUNNER

> **PLEASE NOTE:** If you are unfamiliar with Google Cloud Platform environments or any of the required programming languages and tools below, please consider **NOT USING THIS**!
> Because there's a lot of effort required to prepare your computer before you can run this tool properly, it's important to understand what you're doing first. Therefore, I highly recommend following the lab instructions and learning more for a better understanding.

## REQUIREMENT

1. IDE or Code Editor, [Visual Studio Code](https://code.visualstudio.com/) is Highly Recomended
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
3. Chromium based Browser (Google Chrome, Microsoft Edge, or any other browser)
4. [NodeJS](https://nodejs.org) 18+

**Windows Subsystem for Linux (WSL)** is highly recommended. However, it can also be run directly on Windows, but please make sure to install these requirements first!

1. Bash Shell (You can Use **Git Bash**, install it during the Git installation process)
2. A Package Manager to install bash commands more easily. As an example I use [Chocolatey](https://chocolatey.org/)
3. [jq](https://jqlang.github.io/jq/download/)
    ```bash
    choco install jq
    ```
4. sed
    ```bash
    choco install sed
    ```
5. Additional bash commands that I forgot to include here 🗿. You may notice them when running the script.

## HOW TO START

1. After cloning this repository, run `npm install` or `yarn` to install the dependencies.
2. [Enable browser debugging](#how-to-enable-browser-debugging) and set the port to `9222`.
3. Logout of all your Google accounts, you can use this link 👉 [https://accounts.google.com/logout](https://accounts.google.com/logout)
4. Open the lab you want to execute.
5. Copy the lab identifier and put it into `runner.sh`.
6. Copy the lab URL path and put it into `browser-automation.js`
7. Change `variables` in `browser-automation.js` depending on the lab. You can find the variable for your lab in `VARIABLES.md`.
8. Go to the `sdk-scripts` folder in your bash terminal (WSL, Git Bash, or similar)
9. Change the permissions for all the shell scripts using this command
    ```bash
    find . -name "*.sh" -exec chmod +x {} \;
    ```
10. Run `runner.sh` to start the automation
    ```bash
    ./runner.sh
    ```
    or use this if you are running on a Windows system.
    ```bash
    sh ./runner.sh
    ```
11. Select `Re-initialize this configuration [default] with new settings` in your Terminal, then type `Y` if prompted to log in.
12. Open the given link in your browser and choose `Login with another account`. Leave the tab open, ensuring that the email form remains visible.
13. Then back to your GCSB Tab and click `Start Lab`
14. Copy the `PROJECT ID` and then return to the terminal.
15. Wait until prompted to pick the Project ID, then select `Enter a Project ID`.
16. Paste the `PROJECT ID`, Enter
17. Congratulation!! The Lab will be executed and ended Automatically.
18. Once the lab finishes, you must logout from the Google Account in both your Browser and Terminal. You can run this command in the terminal:
    ```bash
    gcloud auth revoke --all
    ```

### HOW TO ENABLE BROWSER DEBUGGING

1. Right-click on the browser shortcut, then click on `Properties`.

    ![OnPaste 20240717-111322](https://github.com/user-attachments/assets/d0f8bfc1-e80f-4b76-854c-28c8643354a5)

2. Go to the `Shortcut` tab, then edit the `Target` field by adding `--remote-debugging-port=9222`.

    ![OnPaste 20240717-111559](https://github.com/user-attachments/assets/e4cc804e-9e3f-42f6-aea1-daace7545773)

3. Restart the browser.
4. Verify that remote debugging is active by go to [http://localhost:9222/json/version](http://localhost:9222/json/version)
5. It should look like this. If not, it means debugging isn't active. Try restarting the browser via Task Manager or restarting your device.

    ![image](https://github.com/user-attachments/assets/0ba0eec5-a549-4919-bfab-601f35c1f9a5)
