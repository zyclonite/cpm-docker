<!DOCTYPE html>
<html>
<head>
<title>CPM Webserver</title>
<style>
    body {
        text-align: center;
        font-family: Tahoma, Geneva, Verdana, sans-serif;
    }
</style>
</head>
<body>
<h1>CPM Webserver</h1>
<p>If you see PHP info below, Caddy with PHP container works.</p>

<p>More instructions about this image is <a href="//github.com/zyclonite/cpm-docker/blob/master/README.md" target="_blank">here</a>.<p>
<p>More instructions about Caddy is <a href="//caddyserver.com/docs" target="_blank">here</a>.<p>
<?php
    phpinfo()
?>
</body>
</html>
