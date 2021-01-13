<?PHP
$src = $argv[1];
//sri_encrypt($src,"openssl dgst -sha384 -binary"); 
// echo sri_encrypt($src,"sha384"); 
echo "Content-Security-Policy: script-src 'sha256-". sri_encrypt($src,"sha256")."'\n"; 
function sri_encrypt($src,$hash)

{
	$data = file_get_contents($src);
	return base64_encode(hash($hash, $data, true));

}


?>