#!/bin/bash
# Verify all URLs from R1 and R2

echo "===== URL Verification for Task 29 ====="
echo ""

check_url() {
    local url="$1"
    local label="$2"
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" -L "$url" --max-time 15)

    if [ "$http_code" == "200" ]; then
        echo "✓ $label: $url (HTTP $http_code)"
    elif [ "$http_code" == "302" ] || [ "$http_code" == "301" ]; then
        echo "⚠ $label: $url (HTTP $http_code - REDIRECT)"
    elif [ "$http_code" == "000" ]; then
        echo "✗ $label: $url (TIMEOUT or CONNECTION FAILED)"
    else
        echo "✗ $label: $url (HTTP $http_code - FAILED)"
    fi
}

echo "=== R1 URLs ==="
check_url "https://git.savannah.gnu.org/cgit/grep.git" "R1-1: GNU grep cgit"
check_url "https://ftp.gnu.org/gnu/grep/" "R1-2: GNU grep FTP"
check_url "https://cgit.freebsd.org/src/tree/usr.bin/grep/" "R1-3: FreeBSD grep"
check_url "https://github.com/openbsd/src/tree/master/usr.bin/grep" "R1-4: OpenBSD grep"
check_url "https://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/grep/" "R1-5: NetBSD grep"
check_url "https://opensource.apple.com/" "R1-6: Apple opensource"
check_url "https://opensource.apple.com/tarballs/" "R1-7: Apple tarballs"
check_url "https://git.busybox.net/busybox/tree/" "R1-8: BusyBox grep"
check_url "https://github.com/BurntSushi/ripgrep" "R1-9: ripgrep"
check_url "https://github.com/ggreer/the_silver_searcher" "R1-10: silver searcher"

echo ""
echo "=== R2 URLs ==="
check_url "https://git.savannah.gnu.org/git/grep.git" "R2-1: GNU grep git"
check_url "https://git.savannah.gnu.org/git/grep.html" "R2-2: GNU grep web"
check_url "https://www.gnu.org/software/coreutils/" "R2-3: GNU Coreutils"
check_url "https://ftp.gnu.org/gnu/coreutils/" "R2-4: Coreutils FTP"
check_url "https://git.savannah.gnu.org/git/coreutils.git" "R2-5: Coreutils git"
check_url "https://git.busybox.net/busybox/" "R2-6: BusyBox"
check_url "https://cvsweb.openbsd.org/cgi-bin/cvsweb/src/usr.bin/grep/" "R2-7: OpenBSD grep"
check_url "https://github.com/BurntSushi/ripgrep" "R2-8: ripgrep"
check_url "https://opensource.apple.com/source/grep/" "R2-9: Apple grep source"
check_url "https://elixir.bootlin.com/coreutils/git/head/tools/grep" "R2-10: Elixir bootlin"
check_url "https://github.com/OniguramaOniguruma" "R2-11: Oniguruma (LIKELY BROKEN)"
check_url "https://github.com/kkos/oniguruma" "R2-11alt: Oniguruma (CORRECT)"
check_url "https://github.com/paulrubin/grep" "R2-12: Paul Rubin grep"
check_url "https://minnie.tuhs.org/Archive/SourceFiles/V7/" "R2-13: V7 Unix"
check_url "https://nvd.nist.gov/vuln/detail/CVE-2016-3253" "R2-14: CVE reference"

echo ""
echo "===== URL Verification Complete ====="
