$pages = @('start-a-business','accounting','about','contact','index','gst-services','services','blog',
           'ipr','iso-certification','msme-zed','roc-compliance','tax-services','statutory-registrations','licenses')
$dir = 'd:\Website Projects\Required Filings Website\required-filings'

foreach ($p in $pages) {
    $content = [System.IO.File]::ReadAllText("$dir\$p.html", [System.Text.Encoding]::UTF8)
    # Strip script tags so we only check HTML feature usage
    $html = [regex]::Replace($content, '<script[^>]*>[\s\S]*?</script>', '')
    $html = [regex]::Replace($html, '<script\s[^>]+>', '')

    $swiper   = [bool][regex]::Match($html, 'swiper-slide').Success
    $nice     = [bool][regex]::Match($html, 'single-select').Success
    $counter  = [bool][regex]::Match($html, 'class="count"').Success
    $parallax = [bool][regex]::Match($html, 'class="parallaxie').Success
    $magnific = [bool][regex]::Match($html, 'img-popup|video-popup').Success
    $smooth   = [bool][regex]::Match($html, 'rf-scroll-wrapper').Success
    $split    = [bool][regex]::Match($html, 'text-anim|text_invert|agtsub').Success
    $wow      = [bool][regex]::Match($html, 'wow fadeIn').Success

    Write-Host "--- $p ---"
    Write-Host "  swiper=$swiper nice=$nice counter=$counter parallax=$parallax magnific=$magnific smoother=$smooth split=$split wow=$wow"
}
