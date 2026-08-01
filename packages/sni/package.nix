{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  gtk3,
  libappindicator-gtk3,
}:

buildGoModule (finalAttrs: {
  pname = "sni";
  version = "0.0.103";

  src = fetchFromGitHub {
    owner = "alttpo";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-3W1ykRQFp+t3sWbAhS9Mm1412OYtFU6mU1qXCaxE6lE=";
  };

  vendorHash = "sha256-o4CShxZ8HUL2zcIEcdhr7xTjuVUIPj86zyRTYgsC6dc=";

  ldflags = [
    "-X 'main.version=v${finalAttrs.version}'"
    "-X 'main.commit=v${finalAttrs.src.rev}'"
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
  ];

  meta = {
    description = "SNES Interface with gRPC API";
    homepage = "https://github.com/alttpo/sni";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ voidlily ];
  };

  passthru.updateScript = nix-update-script { };
})
