$path = 'd:\Website Projects\Required Filings Website\required-filings\assets\js\main.js'
$enc = [System.Text.Encoding]::UTF8
$encNoBOM = New-Object System.Text.UTF8Encoding $false
$content = [System.IO.File]::ReadAllText($path, $enc)

# Replace stagger 0.03 -> 0.02 and duration 1 -> 0.6 inside text-anim block
# Also add orientation change refresh after the closing }); // End Document Ready

$content = $content -replace 'let staggerAmount = 0\.03,', 'let staggerAmount = 0.02,'
$content = $content -replace '(gsap\.from\(animationSplitText\.chars,\s*\{[^}]*duration:\s*)1(,)', '${1}0.6${2}'

# Add orientation change handler before }); // End Document Ready Function
$orientationCode = @'

    // Refresh ScrollTrigger on orientation change (mobile)
    window.addEventListener("orientationchange", function () {
        setTimeout(function () { ScrollTrigger.refresh(); }, 150);
    });

    }); // End Document Ready Function
'@
$content = $content -replace '\s*\}\); // End Document Ready Function', $orientationCode

[System.IO.File]::WriteAllText($path, $content, $encNoBOM)
Write-Host "Done - text-anim tightened, orientation refresh added"
