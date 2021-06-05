# md_toc
A simple command line tool for inserting automatically generated table of
contents into Markdown files.

# Table of Contents
* [md_toc](#md_toc)
	* [How to use](#how-to-use)
		* [At a glance:](#at-a-glance)
		* [Other options:](#other-options)
	* [How to install](#how-to-install)
	* [Why?](#why)


## How to use
### At a glance: 
```
md_toc
  --inputPath, -i   <path to input>
  --outputPath, -o  <path to output>  (Default=inputPath)
  --inject          <true | false>    (Default=true)
  --top, -t         <true | false>    (Default=false)
```
This is a basic command line tool `md_toc`. The only required parameter is
`inputPath`, which is the path to a Markdown file to process.

By default, the tool will process the `inputPath` Markdown file and insert
the generated linked TOC at a `<<TOC>>` marker located in the file.
The TOC is based purely off of headers located in the input file.

### Other options:
* `outputPath` is the path to an output file, if you don't want the `inputPath`
file touched.
* `inject` is an option that can be set to `false` or `0` to prevent the
injection of the TOC into the Markdown. Instead, it will just output to stdout.
* `top` is an option that can be set to `true` or `1` to inject the generated
TOC at the top of the `outputPath` instead of looking for a `<<TOC>>` marker.

You can always use the `--help` switch for a reminder of the available options.

## How to install
There are a couple of options to install.
1) Local build and install (if you have Nim and Nimble installed):
  a) clone the repo
  b1) build with `nimble build` in the repo directory or,
  b2) build and install into your `.nimble` bin directory with `nimble install`
2) Maybe this will make its way onto the Nimble packages list sometime. If so,
you can just `nimble install md_toc` to get the binary installed to your
`.nimble` bin directory.

## Why?
Ultimately this is just a simple learning project for Nim. It's not the best
way of creating a tool like this and there are a lot of inefficiencies. Also I
just wanted a super lightweight and simple way to generate and inject TOCs
into Markdown files.
