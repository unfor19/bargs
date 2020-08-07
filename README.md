# bargs

[![testing](https://github.com/unfor19/bargs/workflows/testing/badge.svg)](https://github.com/unfor19/bargs/actions?query=workflow%3Atesting)

Wrap your Bash script with command line arguments.

![bargs-demo](https://github.com/unfor19/bargs/blob/master/assets/bargs_demo.gif)

Tired of doing [this - linuxcommand](http://linuxcommand.org/lc3_wss0120.php) or asking yourself [How do I parse command line arguments in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash) easily? Great! Me too! Use this script to wrap your bash scripts with command line arguments, without bashing your head against the wall

Parsing command line arguments in Bash has never been easier!

## Examples

- Take a look at this repository [ecs-stop-task](https://github.com/unfor19/ecs-stop-task) and [replacer](https://github.com/unfor19/replacer), they both demonstrate how bargs is used in real tools
- To run a slim application which uses bargs, run the [example.sh](./example.sh) application with [Docker](https://docs.docker.com/engine/install/)
  ```bash
  $ docker run --rm -it unfor19/bargs:example --help
  ```

## Features

1. **Help Message** is auto generated, set `bargs > description` to update the usage (`--help`) message
1. **Description Per Argument** is supported with `description=What is your name?`
1. **Short and Long Names** are supported with `name=person_name` and `short=n`
1. **Default Value** for each argument can be set with `default=some-value`

   - If `default` contains whitespaces, use double quotes - `default="Willy Wonka"`
   - If `default` starts with a `$`, then it's a variable<br>
     `default=$LANG` is evaluted to `default=en_US.UTF-8`

1. **Allow Empty Values** with `allow_empty=true`
1. **Flag Argument** with `flag=true`, if the flag is provided, its value is true - `CI=true`
1. **Constrain Values** is supported with `options=first second last`, use whitespace as a separator
1. **Prompt** for arguments with `prompt=true`

   - Hide user input with `hidden=true`
   - Prompt for value confirmation with `confirmation=true`

## Requirements

- Bash v4.4+
- Linux Utils - We're printing beautiful stuff with the [column](https://linux.die.net/man/1/column) command, that is included in Linux Utils

### macOS

```bash
$ brew install util-linux
```

### Ubuntu (Debian)

```bash
$ sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Alpine

```bash
$ apk add --no-cache util-linux bash
```

### Windows

Works in Windows-Subsystem-Linux ([WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)) using [Ubuntu 18.04](https://www.microsoft.com/en-il/p/ubuntu-1804-lts/9n9tngvndl3q?rtc=1&activetab=pivot:overviewtab)

<details><summary>More details - Expand/Collapse</summary>

Make sure you use [dos2unix](https://linux.die.net/man/1/dos2unix) on all files, see another example [here](https://github.com/unfor19/bargs/blob/master/.github/workflows/testing.yml)

```powershell
PS> choco install dos2unix
...
PS> dos2unix bargs.sh bargs_vars example.sh tests.sh
...
PS> wsl -u root -d Ubuntu-18.04 -- source example.sh
```

</details>

## Getting Started

1. Download the `bargs.sh` (8 kilobytes) and the `bargs_vars` template

   ```bash
   $ curl -s -L bargs.link/bargs.sh --output bargs.sh
   $ curl -s -L bargs.link/bargs_vars --output bargs_vars
   ```

   **IMPORTANT**! Make sure `bargs.sh` and `bargs_vars` are in the same folder

2. Edit bargs_vars - Declare arguments/variables, here are some ground rules

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - Characters which are not supported: `=`, `~`, `\`

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
description=What's your password?
---
name=happy
short=hp
flag=true
description=Flag for indicating that you're happy
---
name=ci
short=ci
flag=true
description=Flag for indicating it's a CI/CD process
---
name=bargs
description=bash example.sh -n Willy --gender male -a 99
default=irrelevant
---
---
```

<!-- replacer_end_bargsvars -->

</details>

3. Add **one** of the following lines at the beginning of your application (see Usage below)

   - `bargs.sh` is in the root folder of your project (just like in this repo)
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"
     ```
   - `bargs.sh` is in a subfolder, for example `tools`
     ```bash
     source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/tools/bargs.sh "$@"
     ```

4. That's it! You can now reference to arguments that were declared in `bargs_vars`

### Usage

Using the `bargs_vars` above in our application - `example.sh`

```bash
#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret\n"\
"Password:~$password\n"\
"OS Language:~$language\n"\
"I'm happy:~$happy\n"\
"CI Process:~$CI\n"\
"Uppercased var names:~$PERSON_NAME, $AGE years old, from $LOCATION" | column -t -s "~"
```

#### Usage output

<details><summary>
Results after running <a href="https://github.com/unfor19/bargs/blob/master/tests.sh">tests.sh</a> - Expand/Collapse

</summary>

<!-- replacer_start_usage -->

```
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
	--language       |  -lang  [en_US.UTF-8]         default value can be a variable
	--password       |  -p     [REQUIRED]            Whats your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that youre happy
	--ci             |  -ci    [FLAG]                Flag for indicating its a CI/CD process

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Default Values - Should pass
[LOG] Executing: source example.sh -a 99 --gender male -p mypassword
[LOG] Output:

Name:                  Willy Wonka
Age:                   99
Gender:                male
Location:              chocolate factory
Favorite food:
Secret:                !@#%^&*?/.,[]{}+-|
Password:              mypassword
OS Language:           en_US.UTF-8
I'm happy:
CI Process:
Uppercased var names:  Willy Wonka, 99 years old, from chocolate factory

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] New Values - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -p mypassword
[LOG] Output:

Name:                  meir
Age:                   23
Gender:                male
Location:              neverland
Favorite food:
Secret:                !@#%^&*?/.,[]{}+-|
Password:              mypassword
OS Language:           en_US.UTF-8
I'm happy:
CI Process:
Uppercased var names:  meir, 23 years old, from neverland

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Valid Options - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f pizza -p mypassword
[LOG] Output:

Name:                  meir
Age:                   23
Gender:                male
Location:              neverland
Favorite food:         pizza
Secret:                !@#%^&*?/.,[]{}+-|
Password:              mypassword
OS Language:           en_US.UTF-8
I'm happy:
CI Process:
Uppercased var names:  meir, 23 years old, from neverland

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Special Characters - Should pass
[LOG] Executing: source example.sh -a 99 --gender male -s MxTZf+6K\HaAQlt\JWipe1oVRy -p mypassword
[LOG] Output:

Name:                  Willy Wonka
Age:                   99
Gender:                male
Location:              chocolate factory
Favorite food:
Secret:                MxTZf+6K\HaAQlt\JWipe1oVRy
Password:              mypassword
OS Language:           en_US.UTF-8
I'm happy:
CI Process:
Uppercased var names:  Willy Wonka, 99 years old, from chocolate factory

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Use Flag - Should pass
[LOG] Executing: source example.sh -a 23 --gender male --happy -p mypassword -ci
[LOG] Output:

Name:                  Willy Wonka
Age:                   23
Gender:                male
Location:              chocolate factory
Favorite food:
Secret:                !@#%^&*?/.,[]{}+-|
Password:              mypassword
OS Language:           en_US.UTF-8
I'm happy:             true
CI Process:            true
Uppercased var names:  Willy Wonka, 23 years old, from chocolate factory

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Empty Argument - Should fail
[LOG] Executing: source example.sh -a 99 --gender -p mypassword
[LOG] Output:

[HINT] Valid options: male female
[ERROR] Invalid value "-p" for the argument "gender"

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [en_US.UTF-8]         default value can be a variable
	--password       |  -p     [REQUIRED]            Whats your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that youre happy
	--ci             |  -ci    [FLAG]                Flag for indicating its a CI/CD process

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
	--language       |  -lang  [en_US.UTF-8]         default value can be a variable
	--password       |  -p     [REQUIRED]            Whats your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that youre happy
	--ci             |  -ci    [FLAG]                Flag for indicating its a CI/CD process

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Invalid Options - Should fail
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f notgood -p mypassword
[LOG] Output:

[HINT] Valid options: chocolate pizza
[ERROR] Invalid value "notgood" for the argument "favorite_food"

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n     [Willy Wonka]         What is your name?
	--age            |  -a     [REQUIRED]            How old are you?
	--gender         |  -g     [REQUIRED]            male or female?
	--location       |  -l     [chocolate factory]   Where do you live?
	--favorite_food  |  -f     []                    chocolate or pizza?
	--secret         |  -s     [!@#%^&*?/.,[]{}+-|]  special characters
	--language       |  -lang  [en_US.UTF-8]         default value can be a variable
	--password       |  -p     [REQUIRED]            Whats your password?
	--happy          |  -hp    [FLAG]                Flag for indicating that youre happy
	--ci             |  -ci    [FLAG]                Flag for indicating its a CI/CD process

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Missing bargs_vars - Should fail
[LOG] Executing: source example.sh -h
[LOG] Output:

[ERROR] Make sure bargs_vars is in the same folder as bargs.sh

[LOG] Test failed as expected
```

<!-- replacer_end_usage -->

</details>

## Package your application

### Docker

You can use [Docker](https://www.docker.com/why-docker) to package your Bash script as a Docker image, see the following example

1. Clone this repository

1. Build the image, see [Dockerfile.example](./Dockerfile.example), tag it `bargs:example`

   ```bash
   $ docker build -f Dockerfile.example -t bargs:example .
   ```

1. Run a container that is based on the image above :point_up:
   ```bash
   $ docker run --rm -it bargs:example -a 23 -g male
   ```

## Contributing

Report issues/questions/feature requests on the [Issues](https://github.com/unfor19/bargs/issues) section.

Pull requests are welcome! These are the steps:

1. Fork this repo
1. Create your feature branch from master (`git checkout -b my-new-feature`)
1. Add the code of your new feature
1. Run tests on your code, feel free to add more tests
   ```bash
   $ bash tests.sh
   ... # All good? Move on to the next step
   ```
1. Commit your remarkable changes (`git commit -am 'Added new feature'`)
1. Push to the branch (`git push --set-up-stream origin my-new-feature`)
1. Create a new Pull Request and provide details about your changes

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
