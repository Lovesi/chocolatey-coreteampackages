import-module au

$releases = 'https://www.clementine-player.org/downloads'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1"   = @{
      "(?i)^(\s*url\s*=\s*)'.*'"          = "`${1}'$($Latest.URL32)'"
      "(?i)^(\s*checksum\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re      = '\.exe$'
  $url     = $download_page.links | ? href -match $re | select -First 1 -expand href
  $version = Split-Path (Split-Path $url) -Leaf
  @{ URL32 = $url; Version = $version }
}

update -ChecksumFor 32
