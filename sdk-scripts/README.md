# SDK SCRIPT RUNNER

> **PLEASE NOTE:** If you are unfamiliar with Google Cloud Platform environments or any of the required programming languages and tools below, please consider **NOT USING THIS**!
> Because there's a lot of effort required to prepare your computer before you can run this tool properly, it's important to understand what you're doing first. Therefore, I highly recommend following the lab instructions and learning more for a better understanding.

## REQUIREMENT

1. IDE or Code Editor, [Visual Studio Code](https://code.visualstudio.com/) is Highly Recomended
2. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
3. Chromium based Browser (Google Chrome, Microsoft Edge, or any other browser)
4. [NodeJS](https://nodejs.org) 18+

**Windows Subsystem for Linux (WSL)** is highly recommended if you're running on Windows, and You need to install `expect` to interact with command line prompt automatically.

```bash
sudo apt-get install expect
```

However, the scrpts can also be run directly on Windows System, but some of package bellow is required!

1. Bash Shell (You can Use **Git Bash**, Install it during the Git installation process and ensure it's already set in the Windows Environment Variables.)
2. A Package Manager to install bash commands more easily. As an example I use [Chocolatey](https://chocolatey.org/)
3. Bash Command such as [jq](https://jqlang.github.io/jq/download/), `sed`, `cURL` and more. You may notice them when running the script. You can install them through chocolatey.
    ```bash
    choco install jq
    choco install sed
    choco install curl
    ```

## HOW TO START

1. After cloning this repository, run `npm install` or `yarn` to install the dependencies.
2. [Enable browser debugging](#how-to-enable-browser-debugging) and set the port to `9222`.
3. Logout of all your Google accounts, you can use this link 👉 [https://accounts.google.com/logout](https://accounts.google.com/logout)
4. Open the lab you want to execute.
5. Copy the lab ID and put it into `runner.sh`.
   https://github.com/AguzzTN54/gcsb-tricks/blob/23de1872911261440d21a16e8278795faced2937/sdk-scripts/runner.sh#L49-L50
6. Copy the lab URL path and put it into `browser-automation.js`
7. Change the `variables` in `browser-automation.js` depending on the lab. You can find the suitable variable(s) for the lab in [VARIABLES.md](./VARIABLES.md).
   https://github.com/AguzzTN54/gcsb-tricks/blob/873fa5bf6da375308a762366e0c9583f787378bd/sdk-scripts/browser-automation.js#L6-L11
8. Go to the `sdk-scripts` folder in your terminal (WSL Terminal, Git Bash, or similar)
9. Change the permissions for all the shell scripts using this command
    ```bash
    find . -name "*.sh" -exec chmod +x {} \;
    ```
10. Review `runner.sh` once again, change command to run browser automation and initializing Google Cloud SDK, depending on where you run the script:

    ### IN WSL

    - If you run the script in WSL but Node.js is installed on Windows, please specify the path of the Node.js installation in `runner.sh`.
      https://github.com/AguzzTN54/gcsb-tricks/blob/873fa5bf6da375308a762366e0c9583f787378bd/sdk-scripts/runner.sh#L30-L32
    - Then run the script to start the automation process.
        ```bash
        ./runner.sh
        ```
    - Open the provided link from the terminal in your browser, then choose `Login with another account`. Leave the tab open, ensuring that the email field remains visible.
    - Then back to your GCSB Tab and click `Start Lab`
    - Congratulation!! The Lab will be executed and ended Automatically without any other actions

    ### IN WINDOWS SYSTEM

    - You can run the script directly in Windows by executing this command in the Bash terminal:
        ```bash
        sh ./runner.sh
        ```
    - But `./autoinit.sh` will not work, so you need to initialize Google Cloud SDK manually before running the script. Please follow the steps below:

    ### If `expect` Command Does not Supported (not installed or Windows System)

    - Open `runner.sh`, then disable `./autoinit.sh` line and enable `gcloud init --skip-diagnostics`
      https://github.com/AguzzTN54/gcsb-tricks/blob/873fa5bf6da375308a762366e0c9583f787378bd/sdk-scripts/runner.sh#L35-L39
    - Then run `runner.sh`
    - Then Select `Re-initialize this configuration [default] with new settings` in your Terminal, then type `Y` if prompted to log in.
    - Open the given link in your browser and choose `Login with another account`. Leave the tab open, ensuring that the email form remains visible.
    - Then back to your GCSB Tab and click `Start Lab`
    - Copy the `PROJECT ID` and then return to the terminal.
    - Wait until prompted to pick the Project ID, then select `Enter a Project ID`.
    - Paste the `PROJECT ID`, Enter
    - Congratulation!! The Lab will be executed and ended Automatically.

    ### NOTES :

    - Please make sure to set the End of Line Sequence in your editor to `LF`, as it will not work with other types.
      ![OnPaste 20240719-193931](https://github.com/user-attachments/assets/5aea5332-1b0d-40f1-a533-52a2786e3b65)
    - If you encounter an error like this, you can simply ignore it.
      ![image](https://github.com/user-attachments/assets/445d22d7-3a40-46da-a62c-7cdc59b80ed4)
    - Once the lab finishes, **you must logout from the Google Account in both your Browser and Terminal**. You can run this command in the terminal:
        ```bash
        gcloud auth revoke --all
        ```

    This is a demo video in case you want to see how it works before using the tool. (I’m using WSL2 and Node.js installed on a Windows system).

    https://github.com/user-attachments/assets/c9e48d49-b05f-4e63-af0c-3a5e87624c1d

<br/>

---

## HOW TO ENABLE BROWSER DEBUGGING

1. Right-click on the browser shortcut, then click on `Properties`.

    ![OnPaste 20240717-111322](https://github.com/user-attachments/assets/d0f8bfc1-e80f-4b76-854c-28c8643354a5)

2. Go to the `Shortcut` tab, then edit the `Target` field by adding `--remote-debugging-port=9222`.

    ![OnPaste 20240717-111559](https://github.com/user-attachments/assets/e4cc804e-9e3f-42f6-aea1-daace7545773)

3. Restart the browser.
4. Verify that remote debugging is active by go to [http://localhost:9222/json/version](http://localhost:9222/json/version)
5. It should look like this. If not, it means debugging isn't active. Try restarting the browser via Task Manager or restarting your device.

    ![image](https://github.com/user-attachments/assets/0ba0eec5-a549-4919-bfab-601f35c1f9a5)
