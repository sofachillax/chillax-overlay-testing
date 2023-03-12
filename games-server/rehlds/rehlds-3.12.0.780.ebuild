#    Copyright 2023 sofachillax https://github.com/sofachillax/
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

EAPI=8

inherit multiprocessing flag-o-matic

DESCRIPTION="Reverse-engineered (and bugfixed) Half-Life Dedicated Server"
HOMEPAGE="https://github.com/dreamstalker/rehlds"
SRC_URI="https://github.com/dreamstalker/rehlds/archive/refs/tags/3.12.0.780.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-util/cmake-3.10
	>=sys-devel/gcc-4.9.2"

D="/usr/local/rehlds"

pkg_pretend() {
	einfo "Checking compiler for SSE3 support..."
	test-flags-CXX -msse -msse2 -msse3 || die "SSE3 not supported by compiler, quitting."
}

src_compile() {
	einfo "Using GCC as a compiler because this ebuild does not support icc/clang (yet?)"
	./build.sh --jobs=$(makeopts_jobs) --compiler=gcc || die "Compilation unfortunately failed!"
}
src_install() {
	mkdir -p ${D}/valve/dlls
	cp ${S}/build/rehlds/filesystem/FileSystem_Stdio/filesystem_stdio.so ${D}/ || die "filesystem_stdio.so could NOT be installed!"
	cp ${S}/build/rehlds/engine_i486.so ${D}/ || die "engine_i486.so could NOT be installed!"
	cp ${S}/build/rehlds/dedicated/hlds_linux ${D}/ || die "hlds_linux could NOT be installed!"
	cp ${S}/build/rehlds/HLTV/DemoPlayer/demoplayer.so ${D}/ || die "demoplayer.so could NOT be installed!"
	cp ${S}/build/rehlds/HLTV/Director/director.so ${D}/valve/dlls/ || die "director.so could NOT be installed!"
	cp ${S}/build/rehlds/HLTV/Core/core.so ${D}/ || die "core.so could NOT be installed!"
	cp ${S}/build/rehlds/HLTV/Console/hltv ${D}/ || die "hltv could NOT be installed!"
	cp ${S}/build/rehlds/HLTV/Proxy/proxy.so ${D}/ || die "proxy.so could NOT be installed!"
}

pkg_postinst() {
	elog "Remember to copy your ReHLDS binaries and libraries"
	elog "and overwrite the original ones."
	elog "See https://github.com/dreamstalker/rehlds for further help and happy fragging."
}
