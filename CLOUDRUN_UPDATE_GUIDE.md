# 🔧 Cloud Run Environment Variables Update Guide

**Status:** ⚠️ gcloud CLI tidak tersedia di environment ini  
**Solution:** Jalankan di local machine Anda

---

## 📋 Quick Fix (3 Methods)

### Method 1: gcloud CLI (Recommended)

**Prerequisites:**
- Google Cloud SDK installed
- Authenticated with `gcloud auth login`
- Project set to `819208434965`

**Run this command:**

```bash
gcloud run services update ai-vitality \
  --region=us-west1 \
  --update-env-vars="GITHUB_PAT=github_pat_***REDACTED***,GROQ_KEY=gsk_***REDACTED***,GEMINI_KEY=AQ.***REDACTED***,TOKEN=hk-rocspace-2026,OR_KEY=sk-or-***REDACTED***"
```

**Verify:**

```bash
gcloud run services describe ai-vitality \
  --region=us-west1 \
  --format="yaml" | grep -A 20 "env:"
```

---

### Method 2: Google Cloud Console (Easiest)

**Steps:**

1. **Open Cloud Console:**
   - Go to: https://console.cloud.google.com/run
   - Select project: `819208434965`

2. **Select Service:**
   - Click on `ai-vitality` service

3. **Edit & Deploy:**
   - Click "Edit & Deploy New Revision" button

4. **Variables & Secrets Tab:**
   - Go to "Variables & Secrets" tab
   - Scroll to "Environment variables" section

5. **Add/Update Variables:**

   Click "+ ADD VARIABLE" for each:

   | Variable Name | Value |
   |---------------|-------|
   | `GITHUB_PAT` | `github_pat_***REDACTED***` |
   | `GROQ_KEY` | `gsk_***REDACTED***` |
   | `GEMINI_KEY` | `AQ.***REDACTED***` |
   | `TOKEN` | `hk-rocspace-2026` |
   | `OR_KEY` | `sk-or-***REDACTED***` |

6. **Deploy:**
   - Click "Deploy" button
   - Wait 1-2 minutes

---

### Method 3: Using curl with OAuth Token

**Prerequisites:**
- Get OAuth token: `gcloud auth print-access-token`

**Steps:**

1. **Get Access Token:**

```bash
ACCESS_TOKEN=$(gcloud auth print-access-token)
echo "Token: ${ACCESS_TOKEN:0:20}..."
```

2. **Get Current Service:**

```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://us-west1-run.googleapis.com/apis/serving.knative.dev/v1/namespaces/819208434965/services/ai-vitality" \
  > service.json
```

3. **Edit service.json:**

Open `service.json` and find the `containers` section. Add/update environment variables:

```json
{
  "spec": {
    "template": {
      "spec": {
        "containers": [{
          "env": [
            {
              "name": "GITHUB_PAT",
              "value": "github_pat_***REDACTED***"
            },
            {
              "name": "GROQ_KEY",
              "value": "gsk_***REDACTED***"
            },
            {
              "name": "GEMINI_KEY",
              "value": "AQ.***REDACTED***"
            },
            {
              "name": "TOKEN",
              "value": "hk-rocspace-2026"
            },
            {
              "name": "OR_KEY",
              "value": "sk-or-***REDACTED***"
            }
          ]
        }]
      }
    }
  }
}
```

4. **Update Service:**

```bash
curl -X PUT \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d @service.json \
  "https://us-west1-run.googleapis.com/apis/serving.knative.dev/v1/namespaces/819208434965/services/ai-vitality"
```

---

## ✅ Verification

After updating, verify the deployment:

### 1. Check Service Status

```bash
curl https://ai-vitality-819208434965.us-west1.run.app/health | python3 -m json.tool
```

**Expected Output:**
```json
{
    "status": "ok",
    "version": "5.0.0 \"Omni\"",
    "components": 12
}
```

### 2. Test GitHub API

```bash
curl "https://ai-vitality-819208434965.us-west1.run.app/api/github/files?owner=ivansslo&repo=roadfx-ai-stack" \
  -H "Authorization: Bearer hk-rocspace-2026" | python3 -c "
import json,sys
d=json.load(sys.stdin)
if 'files' in d:
    print(f'✅ GitHub API working: {len(d[\"files\"])} files')
else:
    print(f'❌ Error: {d.get(\"error\",\"unknown\")}')
"
```

**Expected Output:**
```
✅ GitHub API working: 54 files
```

### 3. Test AI Chat

```bash
curl -X POST "https://ai-vitality-819208434965.us-west1.run.app/ai/chat" \
  -H "Authorization: Bearer hk-rocspace-2026" \
  -H "Content-Type: application/json" \
  -d '{"model":"llama-3.3-70b-versatile","messages":[{"role":"user","content":"Hello"}]}' | python3 -m json.tool
```

---

## 🐛 Troubleshooting

### Issue: "Permission denied"

**Solution:**
```bash
gcloud auth login
gcloud config set project 819208434965
```

### Issue: "Service not found"

**Solution:**
```bash
# Check if service exists
gcloud run services list --region=us-west1

# If not found, deploy from source
gcloud run deploy ai-vitality \
  --source . \
  --region=us-west1 \
  --allow-unauthenticated
```

### Issue: "Environment variables not updating"

**Solution:**
```bash
# Force new revision
gcloud run services update ai-vitality \
  --region=us-west1 \
  --update-env-vars="FORCE_UPDATE=$(date +%s)"
```

---

## 📊 Environment Variables Reference

| Variable | Purpose | Required |
|----------|---------|----------|
| `GITHUB_PAT` | GitHub API authentication | ✅ Yes |
| `GROQ_KEY` | Groq AI API key | ✅ Yes |
| `GEMINI_KEY` | Google Gemini API key | ✅ Yes |
| `TOKEN` | Worker authentication token | ✅ Yes |
| `OR_KEY` | OpenRouter API key | ⚠️ Optional |

---

## 🎯 Quick Commands

```bash
# Update all environment variables (copy-paste ready)
gcloud run services update ai-vitality \
  --region=us-west1 \
  --update-env-vars="GITHUB_PAT=github_pat_***REDACTED***,GROQ_KEY=gsk_***REDACTED***,GEMINI_KEY=AQ.***REDACTED***,TOKEN=hk-rocspace-2026,OR_KEY=sk-or-***REDACTED***"

# Verify deployment
curl https://ai-vitality-819208434965.us-west1.run.app/health

# Test GitHub API
curl "https://ai-vitality-819208434965.us-west1.run.app/api/github/files?owner=ivansslo&repo=roadfx-ai-stack" \
  -H "Authorization: Bearer hk-rocspace-2026"
```

---

## ✅ Success Criteria

After running the update, you should see:

- ✅ Service status: Ready
- ✅ All environment variables set
- ✅ GitHub API working (54 files)
- ✅ AI Chat working (Groq responses)
- ✅ Solace connected

**Expected Result:** 100% functionality (12/12 tests passing)

---

**Last Updated:** 2026-07-12 09:30 UTC  
**Status:** Ready to execute on local machine
