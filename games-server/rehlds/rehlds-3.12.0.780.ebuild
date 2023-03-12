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

pkg_pretend() {
	einfo "Checking compiler for SSE3 support..."
	test-flags-CXX -msse -msse2 -msse3 || die "SSE3 not supported by compiler, quitting."
}

src_compile() {
	einfo "Using GCC as a compiler because this ebuild does not support icc/clang (yet?)"
	./build.sh --jobs=$(makeopts_jobs) --compiler=gcc || die "Compilation unfortunately failed!"
}

src_install() {
	insinto /opt/rehlds/valve/dlls
	doins build/rehlds/HLTV/Director/director.so

	insinto /opt/rehlds
	doins build/rehlds/filesystem/FileSystem_Stdio/filesystem_stdio.so build/rehlds/engine_i486.so build/rehlds/HLTV/DemoPlayer/demoplayer.so build/rehlds/HLTV/Core/core.so build/rehlds/HLTV/Proxy/proxy.so

	exeinto /opt/rehlds
	doexe build/rehlds/dedicated/hlds_linux build/rehlds/HLTV/Console/hltv
}

pkg_postinst() {
	elog "Remember to copy your ReHLDS binaries and libraries"
	elog "and overwrite the original ones."
	elog "See https://github.com/dreamstalker/rehlds for further help and happy fragging."
}
