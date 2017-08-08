# XSpec Docker Image
XSpec is a unit test and behaviour-driven development (BDD) framework for XSLT, XQuery, and Schematron.

This is the Docker image for XSpec v0.5.0. 

## How to build and run it
*Building instructions are relevant until the XSpec Docker image is accepted in Docker Hub.*

Clone the repository, go to the directory where the Dockerfile is located, and build the Docker image as follow:
```
docker build -t xspec:latest .
```
Run the Docker container with no arguments to check that it works correctly:
```
docker run xspec
```
This should output the help:
```
Saxon script not found, invoking JVM directly instead.

Usage: xspec [-t|-q|-c|-j|-h] filename [coverage]

  filename   the XSpec document
  -t         test an XSLT stylesheet (the default)
  -q         test an XQuery module (mutually exclusive with -t)
  -c         output test coverage report
  -j         output JUnit report
  -h         display this help message
  coverage   deprecated, use -c instead

```
Now run it with the default tutorial file included in XSpec:
```
docker run xspec /xspec/tutorial/escape-for-regex.xspec
```
This should output the following:
```
Saxon script not found, invoking JVM directly instead.

Creating XSpec Directory at /xspec/tutorial/xspec...

Creating Test Stylesheet...

Running Tests...
Testing with SAXON HE 9.7.0.18
No escaping
Must not be escaped at all
Test simple patterns
..When encountering parentheses
escape them.
..When encountering a whitespace character class
escape the backslash
result should have one more character than source
When processing a list of phrases
All phrase elements should remain
Strings should be escaped and status attributes should be added
      FAILED

Formatting Report...
passed: 5 / pending: 0 / failed: 1 / total: 6
Report available at /xspec/tutorial/xspec/escape-for-regex-result.html
Done.
```

## Passing parameters and accessing reports
In the example above both the XSpec test `escape-for-regex.xspec`  and the report `/xspec/tutorial/xspec/escape-for-regex-result.html` are stored within the container and are not accessible from the host as the container exits at the end of its execution. 

To make the report accessible from the localhost and to pass an XSpec test file stored on the localhost, run it with the `-v` flag. This allows to map a volume on the localhost with a volume inside the container. For example:
```
docker run -v /tmp:/input xspec /input/mytest.xspec
``` 
where 

- `/tmp` is the directory on your localhost where `mytest.xspec` and the relevant XSLT you want to test are stored (in other words `/tmp/mytest.xspec` must exist on your machine)
- `/input` is just a convention to define a volume inside the container (in other words `input` can be replaced with anything you like)

This runs the XSpec test `mytest.xspec` inside the Docker container and ends with the message:
```
...
Report available at /input/xspec/mytest-result.html
Done.
```
As `/input` is mapped to `/tmp` on your localhost, the report is available at `/tmp/xspec/mytest-result.html`.

**IMPORTANT**: Make sure that `/tmp` (or any other directory you want to map with the `-v` flag) has 777 permissions as XSpec runs as an unprivileged user inside Docker and needs to write and remove temporary files. To change permissions on your local `/tmp` directory use:
```
sudo chmod 777 /tmp
```
Finally, you can pass any additional parameter that it is supported by XSpec. For example, to run an XSpec test for XQuery add `-q`:
```
docker run -v /tmp:/input xspec -q /input/mytest.xspec
```

## Limitations
At the moment the report is not able to access the CSS file because the path to `/xspec/src/reporter/test-report.css` is only available inside the container. Creating a directory `/xspec/src/reporter` on the local host and copying manually the [CSS file from the XSpec project](https://github.com/xspec/xspec/blob/master/src/reporter/test-report.css) is a workaround to display the report with the CSS formatting until this issue is fixed. A pull request fixing this issue is welcome!

## Feedback
Send us your feedback and questions via [Google Group Mailing List](http://groups.google.com/group/xspec-users) or by [raising an issue](https://github.com/xspec/docker/issues). Pull requests are welcome too!

