# TUIO

[![Build Status](https://travis-ci.com/Ducasse/TUIO.svg?branch=master)](https://travis-ci.com/Ducasse/TUIO)
[![Coverage Status](https://coveralls.io/repos/github//Ducasse/CTUIO/badge.svg?branch=master)](https://coveralls.io/github//Ducasse/TUIO?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Pharo version](https://img.shields.io/badge/Pharo-6.1-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)
<!-- [![Build status](https://ci.appveyor.com/api/projects/status/1wdnjvmlxfbml8qo?svg=true)](https://ci.appveyor.com/project/olekscode/dataframe)  -->



A Protocol for Table-Top Tangible User Interfaces (see http://www.tuio.org)

The TUIO protocol is encoded using the Open Sound Control format, which provides an efficient binary encoding method for the transmission of arbitrary controller data. Therefore the TUIO messages can be basically transmitted through any channel that is supported by an actual OSC implementation.

This port is based on the work of Simon Holland who published it under MIT.

## Installation
The following script installs DataFrame into the Pharo image

```smalltalk
Metacello new
  baseline: 'TUIO';
  repository: 'github://Ducasse/TUIO/src';
  load.
```
