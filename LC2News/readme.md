# <h1>Letztechance.Org lc2news</h1>

## Download

<a href="https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2News/lc2news.exe"><img src="https://www.letztechance.org/img.png?width=400&height=400&image=logo.png&text=lc2news.exe&r=20&g=20&b=20&test=" alt="https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2News/lc2news.exe" width="400" /></a>
- https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2News/lc2news.exe

### required lc2news.config.json

- https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/LC2News/lc2news.config.json


## What is "lc2news.exe" structrure?

it is a part of "LC2Navigator"

	+-------------------------------------------------------------+
	¦               LC2Navigator2027 Desktop App                  ¦
	+-------------------------------------------------------------+
								?
								¦ execute
								¦
	+-------------------------------------------------------------+
	¦      LC2Navigator2027 Desktop Applications                  ¦
	¦                                                             ¦
	¦      - any application                                      ¦
	¦      - ---->lc2news<----                                    ¦
	+-------------------------------------------------------------+
								?
								¦ requests
								¦       

	+-------------------------------------------------------------+
	¦               Apache, PHP, MySQL Service                    ¦
	¦                 (Port 84, Port 3036)                        ¦
	¦  +--------------+              +--------------+             ¦
	¦  ¦   Database   ¦      AND     ¦   PHP        ¦             ¦
	¦  ¦   Backend    ¦              ¦   Backend    ¦             ¦
	¦  +--------------+              +--------------+             ¦
	+-------------------------------------------------------------+
								?
								¦ Token Validation
								¦       

	+-------------------------------------------------------------+
	¦                    Authentication Service                   ¦
	¦                      (Port 8000)                            ¦
	¦  +--------------+              +--------------+             ¦
	¦  ¦   Database   ¦      OR      ¦     LDAP     ¦             ¦
	¦  ¦   Backend    ¦              ¦   Backend    ¦             ¦
	¦  +--------------+              +--------------+             ¦
	+-------------------------------------------------------------+
								?
								¦ Token Validation
								¦
			+---------------------------------------+
			¦                                       ¦
	+-------?--------+                    +--------?-------+
	¦   Service 1    ¦                    ¦   Service 2    ¦
	¦ User Management¦                    ¦ Data Analytics ¦
	¦  (Port 8001)   ¦                    ¦  (Port 8002)   ¦
	+----------------+                    +----------------+


# other readmes

## xml.md

- https://github.com/David-Honisch/Microsoft-Windows/blob/master/LC2News/xml.md

## app.xml
- https://github.com/David-Honisch/Microsoft-Windows/blob/master/LC2News/app.xml
- https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2News/app.xml

## app.xslt
- https://github.com/David-Honisch/Microsoft-Windows/blob/master/LC2News/app.xslt
- https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2News/app.xslt


## Disclaimer

1. Please use this app for downloading only public resources.
2. The app doesn't store ANY media files ANYWHERE except on the device who use this app.

# License

-
- MIT

## License Notes

- read download license 
- mostly open source resources
- read comments

### Copyright

(c)by <webmaster@letztechance.org>
--------------------------
<http://www.letztechance.org>
<http://www.letztechance.org/contact.html>

## Imprint

<http://www.letztechance.org/imprint.html>
