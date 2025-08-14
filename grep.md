- verify
```
curl -I "https://registry.npmjs.org/browserify-sign"

ffuf -w ~/tmp.txt -c -u "https://registry.npmjs.org/FUZZ" -mc all
```
- grep
```
grep -R -E "node_modules/|package.json|dependencies" js_store/
grep -R -E "requirements.txt|setup.py|install_requires" js_store/
grep -R -E "Gemfile|gemspec|gem\s+'" js_store/
grep -R -E "pom\.xml|<dependency>|<groupId>|<artifactId>" js_store/
```

| Ecosystem           | Likely Keywords to Grep For                                                                                               |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **npm / Node.js**   | `node_modules/`, `package.json`, `package-lock.json`, `dependencies`, `devDependencies`, `@scope/`                        |
| **Python / pip**    | `requirements.txt`, `setup.py`, `setup.cfg`, `pyproject.toml`, `install_requires`, `pip install`, `requests` (common lib) |
| **Ruby / RubyGems** | `Gemfile`, `gemspec`, `require '`, `gem '`, `Bundler.require`, `.bundle`, `gem '` with internal-looking names             |
| **Java / Maven**    | `pom.xml`, `<dependency>`, `<groupId>`, `<artifactId>`, `<version>`, `mvn install`, `dependencies>`                       |

