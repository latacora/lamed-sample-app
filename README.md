# lamed-sample-app

An example demonstrating how to build and deploy a clojure native-image lambda to aws using 
the lamed library. Builds and deploys both an uberjar lambda and a native-image exe. Because
it takes a long time to compile native-image executables, it's easier to do development & testing
work w/ an uberjar-based lambda and once the code is verified, compile & deploy with native-image.

## Outline of steps for a clojure native-image lambda:

(this repo implements the below steps)
1. install GraalVM and native-image according to https://www.graalvm.org/getting-started/
2. Add deps.edn alias for nativeimage
3. Add an executable bootstrap bash script that will run your exe built by native-image
4. run `chmod 755 <path/to/bootstrap>` to set the correct permissions on your bootstrap script
4. add lamed as a dependency in deps.edn via :git/url <lamed-repo> & :sha <lamed commit hash>
5. in your handler code, define a -main function that passes your handler func to lamed/delegate!
6. compile your exe w/ clj -A:native-image
7. zip bootstrap and exe into a .zip
8. change lambda terraform code `runtime` property to "provided" and point filename (or s3 bucket/etc.) to .zip from previous step
9. deploy to aws

## Usage

`redeploy.sh` will clean up previous builds, create an uberjar or native-image, and deploy to aws with terraform.

Build & deploy uberjar lambda:

    $ aws-vault exec <your-account> -- redeploy.sh 
    
Build & deploy native-image lambda:

    $ aws-vault exec <your-account> -- redeploy.sh native-image
