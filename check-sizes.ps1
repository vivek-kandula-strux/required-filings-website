$jsDir = 'd:\Website Projects\Required Filings Website\required-filings\assets\js'
$files = @('ScrollSmoother.min.js','ScrollTrigger.min.js','SplitText.min.js','gsap.min.js','wow.min.js','swiper-bundle.min.js','jquery-3.7.1.min.js','jquery.meanmenu.min.js','bootstrap.bundle.min.js')
foreach ($f in $files) {
    $path = "$jsDir\$f"
    $kb = [math]::Round((Get-Item $path).Length / 1024, 1)
    Write-Host "${f}: ${kb} KB"
}
