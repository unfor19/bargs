# bargs

[![testing](https://github.com/unfor19/bargs/workflows/testing/badge.svg)](https://github.com/unfor19/bargs/actions?query=workflow%3Atesting)

Wrap your bash script with command line arguments

Tired of doing [this - linuxcommand](http://linuxcommand.org/lc3_wss0120.php) or asking yourself [How do I parse command line arguments in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash) easily? Great! Me too! Use this script to wrap your bash scripts with command line arguments, without bashing your head against the wall

## Requirements

- Bash v4.4+
- Linux Utils - We're printing beautiful stuff with the [column](https://linux.die.net/man/1/column) command, that is included in Linux Utils

### macOS

```bash
$ brew install util-linux
```

### Linux (Debian/Ubuntu)

```bash
$ sudo apt-get -y update && sudo apt-get install -y bsdmainutils
```

### Windows

Not supported (yet)

## Getting Started

1. Download the script (4 kilobytes) and put it in the same folder as your code

   ```bash
   curl -s -L bargs.link/bargs.sh --output bargs.sh
   ```

1. Creating bargs_vars - do one of the following
   - Create the file `bargs_vars`, put it in the same folder as `bargs.sh`
   - Download the existing `bargs_vars` template
     ```bash
     curl -s -L bargs.link/bargs_vars --output bargs_vars
     ```
1. Declaring arguments/variables

   - The delimiter `---` is required once at the beginning, and **twice** in the end
   - Values which are not supported: `=`, `~`, `(whitespace)`
   - If the `default` is empty or not defined, the argument is required
   - You can't add comments to this file, use the description
   - Use the bargs description to set the `--help` (usage) message
   - The `options` values must separated with a whitespace

   ```bash
   ---
   name=person_name
   short=n
   description=What is your name?
   default=Willy
   ---
   name=age
   short=a
   description=How old are you?
   ---
   name=gender
   short=g
   description='male or female?'
   options=male female
   ---
   name=location
   short=l
   description="Where do you live?"
   default=chocolate-factory
   ---
   name=favorite_food
   short=f
   default=chocolate
   options=chocolate pizza
   description=chocolate or pizza?
   ---
   name=secret
   short=s
   default=!@#$%^&*'"?\/.,[]{}+-|
   description=special characters
   ---
   name=bargs
   description=bash example.sh -n Willy --gender male -a 99
   default=irrelevant
   ---
   ---
   ```

1. Add the following line at the beginning of your application

   ```bash
   source bargs.sh "$@"
   ```

1. That's it! You can now reference to arguments that were declared in `bargs_vars`

### Usage

Using the `bargs_args` above in our application - `example.sh`

```bash
#!/bin/bash
source bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret" | column -t -s "~"
```

#### Usage output

Results after running [tests.sh](https://github.com/unfor19/bargs/blob/master/tests.sh)

```
-------------------------------------------------------
[LOG] Default Values - Should pass
[LOG] Executing: source example.sh -a 99 --gender male
[LOG] Output:

Name:           Willy
Age:            99
Gender:         male
Location:       chocolate-factory
Favorite food:  chocolate
Secret:         !@#$%^&*?\/.,[]{}+-|

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] New Values - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir
[LOG] Output:

Name:           meir
Age:            23
Gender:         male
Location:       neverland
Favorite food:  chocolate
Secret:         !@#$%^&*?\/.,[]{}+-|

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Valid Options - Should pass
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f pizza
[LOG] Output:

Name:           meir
Age:            23
Gender:         male
Location:       neverland
Favorite food:  pizza
Secret:         !@#$%^&*?\/.,[]{}+-|

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Special Characters - Should pass
[LOG] Executing: source example.sh -a 99 --gender male -s MxTZf+6K\HaAQlt\JWipe1oVRy
[LOG] Output:

Name:           Willy
Age:            99
Gender:         male
Location:       chocolate-factory
Favorite food:  chocolate
Secret:         MxTZf+6K\HaAQlt\JWipe1oVRy

[LOG] Test passed as expected
-------------------------------------------------------
[LOG] Empty Argument - Should fail
[LOG] Executing: source example.sh -a 99 --gender
[LOG] Output:

[ERROR] Empty argument: gender

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n  [Willy]                 What is your name?
	--age            |  -a  [Required]              How old are you?
	--gender         |  -g  [Required]              male or female?
	--location       |  -l  [chocolate-factory]     Where do you live?
	--favorite_food  |  -f  [chocolate]             chocolate or pizza?
	--secret         |  -s  [!@#$%^&*?\/.,[]{}+-|]  special characters

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Unknown Argument - Should fail
[LOG] Executing: source example.sh -a 99 -u meir
[LOG] Output:

[ERROR] Unknown argument: -u

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n  [Willy]                 What is your name?
	--age            |  -a  [Required]              How old are you?
	--gender         |  -g  [Required]              male or female?
	--location       |  -l  [chocolate-factory]     Where do you live?
	--favorite_food  |  -f  [chocolate]             chocolate or pizza?
	--secret         |  -s  [!@#$%^&*?\/.,[]{}+-|]  special characters

[LOG] Test failed as expected
-------------------------------------------------------
[LOG] Invalid Options - Should fail
[LOG] Executing: source example.sh -a 23 --gender male -l neverland -n meir -f notgood
[LOG] Output:

[ERROR] Invalid value for argument: favorite_food

Usage: bash example.sh -n Willy --gender male -a 99

	--person_name    |  -n  [Willy]                 What is your name?
	--age            |  -a  [Required]              How old are you?
	--gender         |  -g  [Required]              male or female?
	--location       |  -l  [chocolate-factory]     Where do you live?
	--favorite_food  |  -f  [chocolate]             chocolate or pizza?
	--secret         |  -s  [!@#$%^&*?\/.,[]{}+-|]  special characters

[LOG] Test failed as expected
```

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/bargs/blob/master/LICENSE) file for details
