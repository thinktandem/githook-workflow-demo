A Backdrop CMS site with all the tools for setting up a continuous integration workflow with Pantheon and TravisCI.

## Github

Github is the canonical code repository. Once you've setup the workflow, you should push your changes to Github, and those will be automatically deployed to Pantheon (provided they pass tests) by Travis. To setup with Github...

1. Get access to the Pantheon site (or make a new Backdrop Project).
2. Clone the Pantheon site to your local.
3. Create a new repo on Github.
4. Add that repo as a new remote by running `git remote github [URL of Github repo]`

For more information on the best Github workflow for teams, checkout the [Github Flow](https://guides.github.com/introduction/flow) docs.

## Composer and Tests

We will use composer to download and manage phpcs and other php packages.

1.  Copy the `composer.json` file from this repo to your project.
  * `cp composer.json PATH_TO_YOUR_PROJECT`
2. Run the command `composer install`
  * This command downloads the required packages that are specified in the
  `composer.json` file.
3. Copy the `.phplint.yml` file from this repo to your project.
  * `cp .phplint.yml PATH_TO_YOUR_PROJECT`

## Travis

Travis is where all the build magic happens. The `.travis.yml` file in this repo
describes a number of steps to build, run a few basic tests, and then deploy our
project to production.

If you're working on a new project, follow these steps to get Travis setup:

1. Copy .travis.yml and other necessaries from here into your project:
`cp -r .travis.yml ssh-config PATH_TO_YOUR_PROJECT`
2. Create a public/private key pair for this project
  * `ssh-keygen -t rsa -b 4096 -C "{yourname}@{email.com}"`
    * at the prompts you can name the file whatever you like: I will go with `travis.id_rsa` for this repo.
  * Encrypt the private key with the `travis` cli gem
    * If you don't already have the travis gem installed; install it: `gem install travis` you may need `sudo` for this depending on your system set up
    * Login to travis-ci.org and hook up your github repo to travis.
    * `travis encrypt-file -r {your_github_user_or_org}/{your_repo} travis.id_rsa`
    * Take the output of that command and add it to the `.travis.yml` file.  It will be something like this:
    `openssl aes-256-cbc -K {$encrypted_262c845c1992_key} -iv {$encrypted_262c845c1992_iv} -in travis.id_rsa.enc -out travis.id_rsa -d`
    * Replace the out section of the command with `$HOME/.ssh/travis.id_rsa.enc`
    * Commit the `travis.id_rsa.enc` file to your repo.  DO NOT commit the unecrypted file; add the `travis.id_rsa` and travis.id_rsa.pub to your `.gitignore` file.
3. Modify the line below "Set up our repos" to include your Pantheon repository:
```
  # Set up our repos
  - git remote add upstream [YOUR PANTHEON PROJECT'S GIT REPO PATH]
```
4. Make sure you push these changes to your new Github repo:
`git push github`
5. Go to travisci.org and sign in with your Github account. You should see this Github repository as one of the available options; toggle it on.
6. Go to the Pantheon dashboard and add the public key from the public/private key pair in step 2 (`travis.id_rsa.pub` if you are following exactly) and add that to your keys on your Pantheon profile.

Now when you push a change to your Github repo, it should automatically deploy your changes to Pantheon, provided they pass the testing.


## Pantheon

Pantheon is where the site is hosted! The biggest advantage of using our new workflow with Pantheon is that it helps prevent "blocking" the pipeline to production.

Say, for example, you're working on a big new feature and have deployed that work to the Pantheon "Test" environment so your PM can test it out. If there's a bug on the Live environment, you'll have to do a [hotfix](https://pantheon.io/docs/hotfixes/) to get around it.

In the new workflow, you'd never get into this situation. According to Gitflow, all your work should be on a separate Git branch. This branch is deployed by Travis to Pantheon, where it can be made into a [Multidev environment](https://pantheon.io/docs/multidev/) for testing.
