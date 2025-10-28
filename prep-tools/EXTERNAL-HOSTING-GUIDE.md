# External Hosting Migration Guide

This guide explains how to move your large files to external hosting while keeping your manifest-based architecture.

## Quick Comparison

| Solution | Cost | Bandwidth | Setup | Best For |
|----------|------|-----------|-------|----------|
| **GitHub Releases** | Free | Unlimited | Easy | Most users |
| **Cloudflare R2** | $0.015/GB | FREE | Medium | High traffic |
| **Backblaze B2** | $0.005/GB | Free w/CF | Medium | Cost-conscious |
| **GitHub LFS** | $5/50GB | 50GB/mo | Easy | Small files |

## Option 1: GitHub Releases (Recommended)

### Advantages

- ✅ Completely free
- ✅ No bandwidth limits
- ✅ Built-in versioning
- ✅ No extra infrastructure
- ✅ Files up to 2GB each

### Setup Steps

1. **Create a release for each version:**

   ```powershell
   # Tag and push
   git tag -a stonehenge-v1.0 -m "Stonehenge v1.0 Release"
   git push origin stonehenge-v1.0
   ```

2. **Upload files via GitHub web interface:**
   - Go to repository → Releases → Draft a new release
   - Select your tag
   - Drag & drop your .exe files
   - Publish release

3. **Update manifest with release URLs:**

   ```json
   {
     "slug": "stonehenge",
     "downloads": [
       {
         "filename": "Stonehenge-Setup.exe",
         "platform": "Windows",
         "version": "1.0.0",
         "url": "https://github.com/PedlarGames/pedlargames-content/releases/download/stonehenge-v1.0/Stonehenge-Setup.exe"
       }
     ]
   }
   ```

4. **Frontend Integration:** Your web app reads URLs directly from the manifest

## Quick Start Script

Use the included `migrate-to-releases.ps1` script:

```powershell
.\migrate-to-releases.ps1 -GameOrTool stonehenge -Version 1.0.0 -Type game
```

This will:
- Create the release tag
- Show files to upload
- Generate manifest entries
- Open GitHub release page

## More Options

For detailed information about Cloudflare R2, Backblaze B2, and other hosting solutions, see the full guide in this file.
