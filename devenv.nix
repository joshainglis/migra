{
  pkgs,
  lib,
  config,
  ...
}:
let
  postgresql = pkgs.postgresql_16;
  python = pkgs.python312;
  #  sqlbag = python.pkgs.callPackage ./nix/dependencies/sqlbag.nix { };
  #  schemainspect = python.pkgs.callPackage ./nix/dependencies/schemainspect.nix { inherit sqlbag; };
  #  migra = python.pkgs.callPackage ./package.nix { inherit sqlbag schemainspect; };

in
{
  packages = [
    pkgs.git
    postgresql
    python
    #    migra
    config.languages.python.package.pkgs.psycopg2
    config.languages.python.package.pkgs.packaging
    config.languages.python.package.pkgs.pygments
    config.languages.python.package.pkgs.hatchling
    config.languages.python.package.pkgs.uv
  ];

  languages.python = {
    enable = true;
    package = python;
    uv.enable = true;
    venv.enable = true;
  };

  services.postgres.enable = true;
  services.postgres.package = postgresql;
  services.postgres.listen_addresses = "127.0.0.1";
  services.postgres.initialScript = "CREATE ROLE postgres SUPERUSER LOGIN;";

  enterShell = ''
    git --version
  '';

  scripts.reset.exec = ''
    rm -rf $DEVENV_STATE/postgres
  '';
  process.manager.before = ''reset'';

  enterTest =
    let
      pg_isready = lib.getExe' config.services.postgres.package "pg_isready";
    in
    ''
      echo "Running tests"
      timeout 30 bash -c "until ${pg_isready} -d template1 -q; do sleep 0.5; done"
      export PGUSER=postgres
      uv run pytest tests
    '';

  git-hooks.hooks = {
    actionlint.enable = true;
    ruff.enable = true;
    ruff-format.enable = true;
    check-toml.enable = true;
    deadnix.enable = true;
    nixfmt-rfc-style.enable = true;
    end-of-file-fixer.enable = true;
    markdownlint.enable = false;
    pyupgrade.enable = true;
    ripsecrets.enable = true;
    trufflehog.enable = true;
  };
}
