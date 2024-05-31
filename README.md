# PyPi Mail Bash 📧
Effortlessly Track PyPi Package Updates and Receive Email Notifications automatically by using GitHub actions.

---

## 🚀 Overview
PyPi Mail Bash allows you to monitor the versions of specified PyPi packages and receive an email notification if an update is available.

---

## 🛠️ Setup Guide

### 1. Use this Repository as Template
Create your own repository by clicking [here](https://github.com/new?template_name=pypi-mail-bash&template_owner=hija). 

### 2. Configure Tracked Packages
Open `versions.json` and specify the packages you want to track along with their current versions:
```json
{
  "versions": {
    "great_expectations": "0.18.14",
    "pandas": "2.2.1"
  }
}
```
In this example, the script will track:
- `great_expectations` at version `0.18.14`
- `pandas` at version `2.2.1`

### 3. Workflow Permissions
Navigate to your cloned repository's settings:
- Go to **Code and Automation > Actions > General**.
- Enable **Read and write permissions** for Workflows to allow updates to `versions.json`.

### 4. Set Up Repository Secrets
In your repository settings, go to **Security > Secrets and Variables > Actions** and add the following secrets:

| Name             | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `EMAIL_USER`     | The email address used to send notifications                                |
| `EMAIL_PASSWORD` | The password for the sending email address                                  |
| `SMTP_SERVER`    | The SMTP server for sending emails (e.g., `smtp.gmail.com` for Gmail)       |
| `RECIPIENT_EMAIL`| The email address that will receive update notifications                    |
| `GH_TOKEN`       | A [fine-grained GitHub PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token). Limit it to your cloned repo with read permissions. |

### 5. Run the Workflow
You can perform a dry run of the workflow:
- Navigate to the **Actions** tab in your repository.
- Click on **Check Package Versions** on the left-hand side.
- Click on **Run workflow**.

> **Note:** The workflow will only send an email if package updates are detected. To test it, consider temporarily downgrading a version in `versions.json` to ensure an update is found.

### 6. Automatic Execution
The workflow is scheduled to run automatically every midnight.

---

## 📬 Enjoy Seamless Package Tracking!

Feel free to contribute or report issues. Happy coding! 🚀
