# Concepts

Dollhouse is my idea of a layer around Babushka, making it easy to describe how deployments are configured in a useful way.

## Deployments

The idea of a deployment is a record of exactly what's up there, right now, running. I think that's really important to record, but it's not some high-level abstract architecture diagram - it's a nesting description of exactly how to build our app from parts, too.

## Server Types

This is what you build your server from. A sequence of Babushka deps and inputs. Order is usally important, sometimes local actions need to be run too. Usually expecting the remote process to be running as root, but often deps need to be run as other users too.
