# Maven archetype for java11
Maven archetype for java 8 that includes
1. **lombok** - lombok 1.18.8
2. **junit5** - junit 4.11

## To install locally
Run `mvn clean install`

## To generate new project
```bash
mvn archetype:generate \
 -DarchetypeGroupId=org.arunachalashiva.tools \
 -DarchetypeArtifactId=java8-junit4-lombok \
 -DarchetypeVersion=1.0.0-SNAPSHOT \
 -DgroupId=<group_id> \
 -DartifactId=<my-project> \
 -Dversion=1.0.0-SNAPSHOT \
 -DinteractiveMode=false
```
