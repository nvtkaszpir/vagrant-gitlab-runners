# gitlab-runner in vagrant

Example scripts to run different gitlab runners as virtual machines under
vagrant, as disposable, on-demant workers.

Shell scripts provided so that you really do not need anything else.
This can be easily converted into kickstart/preseed/cloudinit scripts.

Notice that there are already puppet/ansible modules/roles in the world.

# Flavours

- Centos 7.4 + gitlab-runner as docker executor (basic)
- Centos 7.4 + gitlab-runner as shell executor, with docker, java and gcc++

- Ubuntu 16.04 + gitlab-runner as docker executor (basic)
- Ubuntu 16.04 + gitlab-runner as shell executor, with docker, java and gcc++

Centos installs new kernel mainline from elrepo.
Ubuntu installs kernel hwe lts.
OpenJDK 8, headless.

# Preparing

- ensure you have vagrant installed

- ensure you have vagrant plugin vagrant-reload
```bash
vagrant plugin install vagrant-reload
```

- go to your gitlab install, find project
- go to Settings (on the bottom left), CI/CD, Runners settinfs, click expand
- there is a section 'Specific Runners', with url and token in red, copy it.

# Adjusting setup
- go into specific directory
- copy .secrets.dist to .secrets

- edit .secrets and update runner name, url, project token to register and tags

- execute command in shell, to load env vars:
```bash
. .secrets
```

- after command above executed, start vagrant:
```bash
vagrant up
```

- in the end of vagrant execution you should see something in red color (yeah...):
```text
vm-name: Registering runner... succeeded   runner=SOMETHING
vm-name: Runner registered successfully. Feel free to start it,
         but if it's running already the config should be automatically reloaded!
```

- go to the gitlab project, and check if in Runner settings you see registered
  runner.

- check your gitlab project and edit .gitlab-ci.yml to use proper tags in the
  project depending on the build/step and so on.

