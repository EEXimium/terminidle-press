# TERMINIDLE press-kit media generator
# Renders the wordmark, icons and key art in the game's terminal aesthetic.
# Re-run any time:  powershell -ExecutionPolicy Bypass -File tools\generate-media.ps1
Add-Type -AssemblyName System.Drawing

$mediaDir = Join-Path (Split-Path $PSScriptRoot -Parent) "media"
New-Item -ItemType Directory -Force $mediaDir | Out-Null

$GREEN  = [System.Drawing.Color]::FromArgb(255, 51, 255, 153)
$DIMG   = [System.Drawing.Color]::FromArgb(255, 27, 122, 74)
$BLACK  = [System.Drawing.Color]::FromArgb(255, 5, 8, 7)
$GOLD   = [System.Drawing.Color]::FromArgb(255, 255, 217, 64)

function New-Canvas([int]$w, [int]$h, [System.Drawing.Color]$bg) {
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = "AntiAlias"
    $g.TextRenderingHint = "AntiAliasGridFit"
    $g.Clear($bg)
    return @($bmp, $g)
}

# Layered fake glow: dim copies ringed around the core, then the bright pass
function Draw-GlowText($g, [string]$text, $font, [float]$x, [float]$y, [System.Drawing.Color]$core, [int]$radius) {
    $glow = [System.Drawing.Color]::FromArgb(38, $core.R, $core.G, $core.B)
    $gb = New-Object System.Drawing.SolidBrush($glow)
    for ($dx = -$radius; $dx -le $radius; $dx += 2) {
        for ($dy = -$radius; $dy -le $radius; $dy += 2) {
            if ($dx -eq 0 -and $dy -eq 0) { continue }
            $g.DrawString($text, $font, $gb, $x + $dx, $y + $dy)
        }
    }
    $gb.Dispose()
    $cb = New-Object System.Drawing.SolidBrush($core)
    $g.DrawString($text, $font, $cb, $x, $y)
    $cb.Dispose()
}

function Draw-Scanlines($g, [int]$w, [int]$h, [int]$alpha) {
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($alpha, 0, 0, 0), 1)
    for ($y = 0; $y -lt $h; $y += 3) { $g.DrawLine($pen, 0, $y, $w, $y) }
    $pen.Dispose()
}

# ── LOGO (transparent + on-black) ────────────────────────────────────────────
foreach ($variant in @("transparent", "dark")) {
    $w = 1600; $h = 420
    $bg = if ($variant -eq "dark") { $BLACK } else { [System.Drawing.Color]::FromArgb(0,0,0,0) }
    $bmp, $g = New-Canvas $w $h $bg

    $font  = New-Object System.Drawing.Font("Consolas", 118, [System.Drawing.FontStyle]::Bold)
    $small = New-Object System.Drawing.Font("Consolas", 21, [System.Drawing.FontStyle]::Regular)

    $text = "TERMINIDLE"
    $size = $g.MeasureString($text, $font)
    # leave room for the cursor block on the right
    $tx = [float](($w - $size.Width - 70) / 2)
    $ty = [float](($h - $size.Height) / 2 - 22)
    Draw-GlowText $g $text $font $tx $ty $GREEN 6

    # blinking-cursor block after the name
    $cbrush = New-Object System.Drawing.SolidBrush($GREEN)
    $cx = $tx + $size.Width - 12; $cy = $ty + 42
    $g.FillRectangle($cbrush, $cx, $cy, 58, [float]($size.Height - 96))
    $cbrush.Dispose()

    # prompt line above, tagline below
    $dimBrush = New-Object System.Drawing.SolidBrush($DIMG)
    $g.DrawString("user@darknet:~$ ./ascend", $small, $dimBrush, $tx + 6, $ty - 20)
    $tag = "the incremental hacking game that boots its own OS"
    $tagSize = $g.MeasureString($tag, $small)
    $g.DrawString($tag, $small, $dimBrush, [float](($w - $tagSize.Width) / 2), $ty + $size.Height + 4)
    $dimBrush.Dispose()

    if ($variant -eq "dark") { Draw-Scanlines $g $w $h 50 }

    $out = if ($variant -eq "dark") { "logo-dark.png" } else { "logo.png" }
    $bmp.Save((Join-Path $mediaDir $out), [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $font.Dispose(); $small.Dispose()
    Write-Host "wrote media/$out"
}

# ── ICONS (">_" terminal mark) ───────────────────────────────────────────────
foreach ($isz in @(512, 256)) {
    $bmp, $g = New-Canvas $isz $isz $BLACK

    # inset border frame
    $pen = New-Object System.Drawing.Pen($DIMG, [float]($isz * 0.016))
    $inset = [float]($isz * 0.055)
    $g.DrawRectangle($pen, $inset, $inset, $isz - 2 * $inset, $isz - 2 * $inset)
    $pen.Dispose()

    $font = New-Object System.Drawing.Font("Consolas", [float]($isz * 0.42), [System.Drawing.FontStyle]::Bold)
    $mark = ">_"
    $ms = $g.MeasureString($mark, $font)
    Draw-GlowText $g $mark $font ([float](($isz - $ms.Width) / 2)) ([float](($isz - $ms.Height) / 2 - $isz * 0.02)) $GREEN ([int][Math]::Max(3, $isz * 0.012))

    Draw-Scanlines $g $isz $isz 42
    $bmp.Save((Join-Path $mediaDir "icon-$isz.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $font.Dispose()
    Write-Host "wrote media/icon-$isz.png"
}

# ── KEY ART 1920x1080 ────────────────────────────────────────────────────────
$w = 1920; $h = 1080
$bmp, $g = New-Canvas $w $h $BLACK
$rand = New-Object System.Random(7)   # fixed seed → reproducible art

# faint digital-rain backdrop
$rainFont = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Regular)
$glyphs = "01<>/#%&@!?;:+=~^$".ToCharArray()
for ($col = 0; $col -lt 96; $col++) {
    $x = $col * 20 + $rand.Next(-4, 4)
    $len = $rand.Next(6, 30)
    $yTop = $rand.Next(-200, $h)
    for ($i = 0; $i -lt $len; $i++) {
        $alpha = [int](8 + 30 * ($i / [float]$len))     # brighter toward the head
        if ($i -eq $len - 1) { $alpha = 70 }
        $b = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 51, 255, 153))
        $ch = [string]$glyphs[$rand.Next($glyphs.Length)]
        $g.DrawString($ch, $rainFont, $b, [float]$x, [float]($yTop + $i * 18))
        $b.Dispose()
    }
}
$rainFont.Dispose()

# center darkening so the title pops (cheap vignette band)
$band = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 5, 8, 7))
$g.FillRectangle($band, 0, [float]($h/2 - 190), $w, 380)
$band.Dispose()

$titleFont = New-Object System.Drawing.Font("Consolas", 128, [System.Drawing.FontStyle]::Bold)
$tagFont   = New-Object System.Drawing.Font("Consolas", 28, [System.Drawing.FontStyle]::Regular)
$subFont   = New-Object System.Drawing.Font("Consolas", 19, [System.Drawing.FontStyle]::Regular)

$title = "TERMINIDLE"
$ts = $g.MeasureString($title, $titleFont)
$tx = [float](($w - $ts.Width - 60) / 2)
$ty = [float]($h/2 - $ts.Height/2 - 40)
Draw-GlowText $g $title $titleFont $tx $ty $GREEN 7
$cbrush = New-Object System.Drawing.SolidBrush($GREEN)
$g.FillRectangle($cbrush, $tx + $ts.Width - 14, $ty + 48, 62, [float]($ts.Height - 108))
$cbrush.Dispose()

$tag = "HACK. IDLE. ASCEND."
$tags = $g.MeasureString($tag, $tagFont)
Draw-GlowText $g $tag $tagFont ([float](($w - $tags.Width)/2)) ([float]($ty + $ts.Height + 6)) $GOLD 3

$sub = "from one blinking cursor to an entire operating system  //  PC"
$subs = $g.MeasureString($sub, $subFont)
$dimBrush = New-Object System.Drawing.SolidBrush($DIMG)
$g.DrawString($sub, $subFont, $dimBrush, [float](($w - $subs.Width)/2), [float]($ty + $ts.Height + 62))
$prompt = "user@darknet:~$ ./ascend"
$g.DrawString($prompt, $subFont, $dimBrush, [float]$tx, [float]($ty - 34))
$dimBrush.Dispose()

Draw-Scanlines $g $w $h 46
$bmp.Save((Join-Path $mediaDir "keyart-1920x1080.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose(); $titleFont.Dispose(); $tagFont.Dispose(); $subFont.Dispose()
Write-Host "wrote media/keyart-1920x1080.png"

Write-Host "done."
