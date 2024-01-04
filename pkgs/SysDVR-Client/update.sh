TMPDIR=$(mktemp -d)
PKGS=$TMPDIR/packages

cd SysDVR/Client
dotnet restore -p:Deterministic=true --packages $PKGS
cd ../..

echo "{ fetchNuGet }: ["

for pkg in $(ls $PKGS); do    
    for ver in $(ls $PKGS/$pkg); do
        hash=$(nix-prefetch-url https://www.nuget.org/api/v2/package/$pkg/$ver --print-path --name "${pkg}-${ver}.nupkg" | sed -n 1p)
    
        echo "  (fetchNuGet { pname = \"$pkg\"; version = \"$ver\"; sha256 = \"$hash\"; })"
    done
done

echo "]"
