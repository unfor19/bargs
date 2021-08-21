# bargs

[![testing](https://github.com/unfor19/bargs/workflows/testing/badge.svg)](https://github.com/unfor19/bargs/actions?query=workflow%3Atesting)

A utility for creating a Bash CLI application.

![bargs-demo](https://d33vo9sj4p3nyc.cloudfront.net/bargs/bargs-example.gif)

## Examples

- Run the [example.sh](https://github.com/unfor19/bargs/blob/master/example.sh) application with [Docker](https://docs.docker.com/engine/install/)
  ```bash
  $ docker run --rm -it unfor19/bargs:example --help
  ```
- For more examples, take a look at the following repositories
  - [unfor19/modulecost](https://github.com/unfor19/modulecost)
  - [unfor19/replacer](https://github.com/unfor19/replacer)
  - [unfor19/ecs-stop-task](https://github.com/unfor19/ecs-stop-task)

## Features

1. **Help Message** is auto generated, set `bargs > description` to update the usage (`--help`) message
1. **Short and Long Names** are supported with `name=person_name` and `short=n`
1. **Description Per Argument** is supported with `description=What is your name?`
1. **Flexible Assignment** enables passing arguments with the equal sign or a whitespace
   - `example.sh --name "Willy Wonka"`
   - `example.sh --name="Willy Wonka"`
1. **Default Value** for each argument can be set with `default=some-value`

   - If `default` contains whitespaces, use double quotes - `default="Willy Wonka"`
   - If `default` starts with a `$`, then it's a variable<br>
     `default=$LANG` is evaluted to `default=en_US.UTF-8`

1. **Allow Environment Variables** with `allow_env_var=true`, if argument is empty then the environment variable will be used. If environment variable is empty, the `default` will be used
   - Environment variable name must be UPPERCASED, `export USERNAME=willywonka`
   - Available in your application as `$USERNAME` or `$username`
1. **Allow Empty Values** with `allow_empty=true`
1. **Flag Argument** with `flag=true`, if the flag is provided, its value is true - `CI=true`
1. **Constrain Values** is supported with `options=first second last`, use whitespace as a separator
1. **Prompt** for arguments with `prompt=true`

   - Hide user input with `hidden=true`
   - Prompt for value confirmation with `confirmation=true`

## Requirements

- Bash v4.4+
- Util-Linux - We're printing beautiful stuff with the [column](https://linux.die.net/man/1/column) command

### macOS

```bash
brew install util-linux
```

### Ubuntu (Debian)

```bash
sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Alpine

```bash
apk add --no-cache util-linux bash
```

### CentOS

```bash
yum update -y && yum install -y util-linux bash
```

### Windows

Works in Windows-Subsystem-Linux ([WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)) using [Ubuntu 18.04](https://www.microsoft.com/en-il/p/ubuntu-1804-lts/9n9tngvndl3q?rtc=1&activetab=pivot:overviewtab)

<details><summary>More details - Expand/Collapse</summary>

Make sure you use [dos2unix](https://linux.die.net/man/1/dos2unix) on all files, see another example [here](https://github.com/unfor19/bargs/blob/master/.github/workflows/testing.yml)

```powershell
choco install dos2unix
# ...
dos2unix bargs.sh bargs_vars example.sh tests.sh
# ...
wsl -u root -d Ubuntu-18.04 -- source example.sh
```

</details>

## Getting Started

1. Download `bargs.sh` (10 kilobytes) and the `bargs_vars` template

   - Latest version (master)
     ```bash
	 curl -sL --remote-name-all bargs.link/{bargs.sh,bargs_vars}
	 ```
   - Specific release (v1.x.x)
     ```bash
	 curl -sL --remote-name-all bargs.link/1.1.4/{bargs.sh,bargs_vars}
	 ```

2. Reference to `bargs_vars` - do one of the following

   - Default behavior - `bargs.sh` and `bargs_vars` are in the same folder
   - Specific `bargs_vars` path - `export BARGS_VARS_PATH="${PWD}/path/to/my_bargs_vars"`, see [tests.sh](https://github.com/unfor19/bargs/blob/master/tests.sh#L37-L38)

3. Edit `bargs_vars` - Declare arguments/variables, here are some ground rules

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - Characters which are not supported: `=`, `~`, `\`, `'`, `"`
   - The last variable `bargs` is necessary, comments below
   - It's best to `source` bargs at the top of the bash script. **Do not** add `set -o pipefail` before `source bargs.sh`

```
---
name=bargs                                                # DON'T TOUCH!
description=bash example.sh -n Willy --gender male -a 99  # Editable, that's the usage message
default=irrelevant                                        # DON'T TOUCH!
---
---
```

<details><summary>bargs_vars - Expand/Collpase</summary>

<!-- replacer_start_bargsvars -->

```
---
name=person_name
short=n
description=What is your name?
default="Willy Wonka"
---
name=age
short=a
description=How old are you?
prompt=true
confirmation=true
---
name=gender
short=g
description=male or female?
options=male female
prompt=true
---
name=location
short=l
description=Where do you live?
default="chocolate factory"
---
name=favorite_food
short=f
allow_empty=true
options=chocolate pizza
description=chocolate or pizza?
---
name=secret
short=s
default=!@#%^&*?/.,[]{}+-|
description=special characters
---
name=language
short=lang
default=$LANG
description=default value can be a variable
---
name=password
short=p
prompt=true
hidden=true
confirmation=true
description=What is your password?
---
name=happy
short=hp
flag=true
description=Flag for indicating that you are happy
---
name=ci
short=ci
flag=true
description=Flag for indicating it is a CI/CD process
---
name=username
short=un
allow_env_var=true
description=Username fetched from environment variable
default=willywonka
---
name=bargs
description=bash example.sh -n Willy --gender male -a 99
default=irrelevant
---
---
```

<!-- replacer_end_bargsvars -->

</details>

4. Add **one** of the following lines at the beginning of your application (see Usage below)

   - `bargs.sh` is in the root folder of your project (just like in this repo)
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"
     ```
   - `bargs.sh` is in a subfolder, for example `tools`
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/tools/bargs.sh "$@"
     ```

5. The arguments are now available as environment variables, both lowercased and UPPERCASED (see Usage below)

### Usage

Using the `bargs_vars` above in our application - `example.sh`

```bash
#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo "
Name:                  ~ $person_name
Age:                   ~ $age
Gender:                ~ $gender
Location:              ~ $location
Favorite food:         ~ $favorite_food
Secret:                ~ $secret
Password:              ~ $password
OS Language:           ~ $language
I am happy:            ~ $happy
CI Process:            ~ $CI
Uppercased var names:  ~ $PERSON_NAME, $AGE years old, from $LOCATION
Username from env var: ~ $username " \
    | column -t -s "~"
```

#### Usage output

<details><summary>
Results after running <a href="https://github.com/unfor19/bargs/blob/master/tests.sh">tests.sh</a> - Expand/Collapse

</summary>

<!-- replacer_start_usage -->

```
-------------------------------------------------------
[LOG] Bargs Vars Path - Should pass
[LOG] Executing: source example.sh -a 33 --gender male -p mypassword
[LOG] Output:

Name:                     Oompa Looma
Age:                      33
Gender:                   male
Location:                 chocolate factory
Favorite food:            
Secret:                   !@#%^&*?/.,[]{}+-|
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               
CI Process:               
Uppercased var names:     Oompa Looma, 33 years old, from chocolate factory
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Help Menu - Should pass
[LOG] Executing: source example.sh -h
[LOG] Output:


Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable
	--password       |  -p     [REQUIRED]            What is your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that you are happy
	--ci             |  -ci    [FLAG]                Flag for indicating it is a CI/CD process
	--username       |  -un    [willywonka]          Username fetched from environment variable

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Default Values - Should pass
[LOG] Executing: source example.sh -a 99 --gender=male -p mypassword
[LOG] Output:

Name:                     Willy Wonka
Age:                      99
Gender:                   male
Location:                 chocolate factory
Favorite food:            
Secret:                   !@#%^&*?/.,[]{}+-|
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               
CI Process:               
Uppercased var names:     Willy Wonka, 99 years old, from chocolate factory
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] New Values - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l=neverland -n meir -p mypassword
[LOG] Output:

Name:                     meir
Age:                      23
Gender:                   male
Location:                 neverland
Favorite food:            
Secret:                   !@#%^&*?/.,[]{}+-|
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               
CI Process:               
Uppercased var names:     meir, 23 years old, from neverland
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Valid Options - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f pizza -p=mypassword
[LOG] Output:

Name:                     meir
Age:                      23
Gender:                   male
Location:                 neverland
Favorite food:            pizza
Secret:                   !@#%^&*?/.,[]{}+-|
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               
CI Process:               
Uppercased var names:     meir, 23 years old, from neverland
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Special Characters - Should pass
[LOG] Executing: source example.sh -a 99 --gender male -s MxTZf+6KHaAQltJWipe1oVRy -p mypassword
[LOG] Output:

Name:                     Willy Wonka
Age:                      99
Gender:                   male
Location:                 chocolate factory
Favorite food:            
Secret:                   MxTZf+6KHaAQltJWipe1oVRy
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               
CI Process:               
Uppercased var names:     Willy Wonka, 99 years old, from chocolate factory
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Use Flag - Should pass
[LOG] Executing: source example.sh -a 23 --gender male --happy -p mypassword -ci
[LOG] Output:

Name:                     Willy Wonka
Age:                      23
Gender:                   male
Location:                 chocolate factory
Favorite food:            
Secret:                   !@#%^&*?/.,[]{}+-|
Password:                 mypassword
OS Language:              C.UTF-8
I am happy:               true
CI Process:               true
Uppercased var names:     Willy Wonka, 23 years old, from chocolate factory
Username from env var:    runner 

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Empty Argument - Should fail
[LOG] Executing: source example.sh -a 99 --gender -p mypassword
[LOG] Output:

[HINT] Valid options: male OR female
[ERROR] Invalid value "-p" for the argument "gender"

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable
	--password       |  -p     [REQUIRED]            What is your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that you are happy
	--ci             |  -ci    [FLAG]                Flag for indicating it is a CI/CD process
	--username       |  -un    [willywonka]          Username fetched from environment variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Unknown Argument - Should fail
[LOG] Executing: source example.sh -a 99 -u meir -p mypassword
[LOG] Output:

[ERROR] Unknown argument "-u"

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable
	--password       |  -p     [REQUIRED]            What is your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that you are happy
	--ci             |  -ci    [FLAG]                Flag for indicating it is a CI/CD process
	--username       |  -un    [willywonka]          Username fetched from environment variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Invalid Options - Should fail
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f notgood -p mypassword
[LOG] Output:

[HINT] Valid options: chocolate OR pizza
[ERROR] Invalid value "notgood" for the argument "favorite_food"

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [C.UTF-8]             default value can be a variable
	--password       |  -p     [REQUIRED]            What is your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that you are happy
	--ci             |  -ci    [FLAG]                Flag for indicating it is a CI/CD process
	--username       |  -un    [willywonka]          Username fetched from environment variable

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Missing bargs_vars - Should fail
[LOG] Executing: source example.sh -h
[LOG] Output:

[ERROR] Make sure bargs_vars is in the same folder as bargs.sh
	Another option - export BARGS_VARS_PATH="/path/to/my_bargs_vars"

[LOG] Test failed as expected
```

<!-- replacer_end_usage -->

</details>

## Package your application with Docker

You can use [Docker](https://www.docker.com/why-docker) to package your Bash script as a Docker image, see the following example

1. Clone this repository

1. Build the image, see [Dockerfile.example](https://github.com/unfor19/bargs/blob/master/Dockerfile.example), tag it `bargs:example`

   ```bash
   docker build -f Dockerfile.example -t bargs:example .
   ```

1. Run a container that is based on the image above
   ```bash
   docker run --rm -it bargs:example -a 23 -g male
   ```

## Use this repository as a template

Thinking of writing a new Bash script? Hit the [Use this template](https://github.com/unfor19/bargs/generate) button and get a fully working example of bargs, including [GitHub Actions workflows](https://github.com/unfor19/bargs/tree/master/.github/workflows).

## Contributing

Report issues/questions/feature requests on the [Issues](https://github.com/unfor19/bargs/issues) section.

Pull requests are welcome! These are the steps:

1. Fork this repo
1. Create your feature branch from master (`git checkout -b my-new-feature`)
1. Add the code of your new feature
1. Run tests on your code, feel free to add more tests
   ```bash
   bash tests.sh
   ... # All good? Move on to the next step
   ```
1. Commit your remarkable changes (`git commit -am 'Added new feature'`)
1. Push to the branch (`git push --set-up-stream origin my-new-feature`)
1. Create a new Pull Request and provide details about your changes

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
