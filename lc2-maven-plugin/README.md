# lc2-maven-plugin

support following mojos:
copy-dist, move-dist, package-dist

copy, move or package your external distributions (dist folder) to your target

## Getting Started

mvn org.letztechance.maven:lc2-maven-plugin:version
or see usage(s) examples

### Maven Plugin
...
<plugin>
                <groupId>org.letztechance.maven</groupId>
                <artifactId>lc2mavenplugin</artifactId>
                <version>1.0-SNAPSHOT</version>
                <configuration>
                    <!-- optional, the command parameter can be changed here too -->
                    <command2>call echo git rev-parse --short=4 HEAD</command2>
					<command3>ant -buildfile %~dp0build.xml</command3>
					<command>exec.bat ant</command>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>version</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <plugin>
                <groupId>com.github.ekryd.echo-maven-plugin</groupId>
                <artifactId>echo-maven-plugin</artifactId>
                <version>1.2.0</version>
                <inherited>false</inherited>
                <executions>
                    <execution>
                        <id>end</id>
                        <goals>
                            <goal>echo</goal>
                        </goals>
                        <phase>process-resources</phase>
                        <configuration>
                            <message>${line.separator}${line.separator}
                                The project version is ${project.version}-${version}
                                ${line.separator}
                            </message>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            

			<plugin>
			<groupId>org.letztechance.maven</groupId>
			<artifactId>lc2mavenplugin</artifactId>
			<version>1.0-SNAPSHOT</version>
			<executions>
					<execution>
					<id>move-dist</id>
					<phase>package</phase>
					<goals>
					<goal>package-dist</goal>
					</goals>
					</execution>
				</executions>
			</plugin>
...


#### Tutorials: How to build a Maven Plugin

This repository contains example code for an Apache Maven Plugin.  To see see how this was build, take a look at the corresponding blog post: [How to Build a Maven Plugin](https://developer.okta.com/blog/2019/09/23/tutorial-build-a-maven-plugin)

**Prerequisites:**

- [Java 8](https://adoptopenjdk.net/)
- [Maven 3](https://maven.apache.org/download.cgi)
