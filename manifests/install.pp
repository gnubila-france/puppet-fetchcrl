#Class fetchcrl::install
class fetchcrl::install (
  $pkgname   = $fetchcrl::pkgname,
  $capkgs    = $fetchcrl::capkgs,
  $carepo    = $fetchcrl::carepo,
  $manage_carepo = $fetchcrl::manage_carepo,
  $capkgs_version = $fetchcrl::capkgs_version,
  $pkg_version = $fetchcrl::pkg_version
) inherits fetchcrl {

  # The fetch-crl or fetch-crl3 package.
  package{$pkgname:
    ensure => $pkg_version,
  }

  if $manage_carepo {
    file{'/etc/pki/rpm-gpg/GPG-KEY-EUGridPMA-RPM-3':
      ensure  => file,
      source  => 'puppet:///modules/fetchcrl/GPG-KEY-EUGridPMA-RPM-3',
      replace => false,
      owner   => root,
      group   => root,
      mode    => '0644',
    }

    yumrepo{'carepo':
      descr    => 'IGTF CA Repository',
      enabled  => 1,
      baseurl  => $carepo,
      gpgcheck => 1,
      gpgkey   => 'file:///etc/pki/rpm-gpg/GPG-KEY-EUGridPMA-RPM-3',
      require  => File['/etc/pki/rpm-gpg/GPG-KEY-EUGridPMA-RPM-3'],
    }

    $capkgs_require = Yumrepo['carepo']
  } else {
    $capkgs_require = undef
  }
  # The CA meta package.
  if ! defined(Package[$capkgs]) {
    package{$capkgs:
      ensure  => $capkgs_version,
      require => $capkgs_require,
    }
  }
}
