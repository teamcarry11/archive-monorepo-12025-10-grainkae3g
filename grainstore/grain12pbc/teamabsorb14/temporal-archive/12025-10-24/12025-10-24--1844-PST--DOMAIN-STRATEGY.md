# 🌾 Grain6pbc Domain Strategy & Cost Optimization

## 🎯 **New Domain Portfolio**

### **Active Domains (Squarespace Domains - 1 Year)**
- **grain12pbc.com** - Main Grain Network website
- **grain12pbc.net** - Network infrastructure and services
- **grain12pbc.org** - Organization and community
- **grainpbc.com** - Core Grain Network platform
- **grainpbc.net** - Platform infrastructure
- **grainpbc.org** - Platform organization

### **Cancelled Domains (Cost Optimization)**
- **grainsix.com** - Cancelled for refund
- **grainsix.net** - Cancelled for refund
- **grainsix.org** - Cancelled for refund
- **grain6.com** - Cancelled for refund
- **grain6.net** - Cancelled for refund
- **grain6.org** - Cancelled for refund

## 💰 **Cost Analysis**

### **Before (3-Year Purchases)**
- grainsix.com/.net/.org (3 years) = ~$150-200
- grain6.com/.net/.org (3 years) = ~$150-200
- **Total**: ~$300-400

### **After (1-Year Purchases)**
- grain12pbc.com/.net/.org (1 year) = ~$50-70
- grainpbc.com/.net/.org (1 year) = ~$50-70
- **Total**: ~$100-140
- **Savings**: ~$200-260

## 🌐 **Domain Strategy**

### **Primary Domains**
- **grain12pbc.com** → Main Grain Network website
- **grainpbc.com** → Core platform and services

### **Infrastructure Domains**
- **grain12pbc.net** → Network services and APIs
- **grainpbc.net** → Platform infrastructure

### **Organization Domains**
- **grain12pbc.org** → Community and organization
- **grainpbc.org** → Platform organization

## 🔄 **DNS Configuration**

### **grain12pbc.com**
```
A     @      → GitHub Pages IP
CNAME www    → grain12pbc.github.io
CNAME api    → api.grain12pbc.net
CNAME docs   → docs.grain12pbc.org
```

### **grainpbc.com**
```
A     @      → GitHub Pages IP
CNAME www    → grainpbc.github.io
CNAME app    → app.grainpbc.net
CNAME admin  → admin.grainpbc.org
```

### **Subdomain Strategy**
- **api.grain12pbc.net** → API services
- **app.grainpbc.net** → Application services
- **docs.grain12pbc.org** → Documentation
- **admin.grainpbc.org** → Administration

## 📋 **Repository Domain Mapping**

### **grain12pbc Organization**
- **grain12pbc/grain6** → grain12pbc.com
- **grain12pbc/grainkae3g** → kae3g.grain12pbc.com
- **grain12pbc/graincontacts** → contacts.grain12pbc.com
- **grain12pbc/humble-stack** → ui.grain12pbc.com
- **grain12pbc/graindaemon** → daemon.grain12pbc.com

### **grainpbc Organization**
- **grainpbc/core** → grainpbc.com
- **grainpbc/api** → api.grainpbc.net
- **grainpbc/docs** → docs.grainpbc.org
- **grainpbc/admin** → admin.grainpbc.org

## 🚀 **Implementation Plan**

### **Phase 1: Domain Setup**
1. ✅ Purchase grain12pbc and grainpbc domains
2. 🔄 Cancel grainsix and grain6 domains
3. ⏳ Configure DNS records
4. ⏳ Set up SSL certificates

### **Phase 2: Repository Updates**
1. ⏳ Update repository descriptions with new domains
2. ⏳ Configure GitHub Pages custom domains
3. ⏳ Update documentation and links
4. ⏳ Test domain resolution

### **Phase 3: Migration**
1. ⏳ Migrate from GitHub Pages to custom domains
2. ⏳ Update all internal links
3. ⏳ Test functionality
4. ⏳ Monitor performance

## 🔧 **Technical Configuration**

### **GitHub Pages Custom Domains**
```yaml
# .github/workflows/deploy.yml
- name: Configure custom domain
  run: |
    echo "grain12pbc.com" > CNAME
    git add CNAME
    git commit -m "Add custom domain" || true
```

### **DNS Records (Squarespace)**
```
Type    Name    Value
A       @       185.199.108.153
A       @       185.199.109.153
A       @       185.199.110.153
A       @       185.199.111.153
CNAME   www     grain12pbc.github.io
```

### **SSL Configuration**
- **Let's Encrypt** via GitHub Pages
- **Automatic renewal** via GitHub Actions
- **HSTS headers** for security

## 📊 **Monitoring & Analytics**

### **Domain Health**
- **Uptime monitoring** for all domains
- **SSL certificate monitoring**
- **DNS resolution testing**
- **Performance monitoring**

### **Analytics**
- **Google Analytics** for grain12pbc.com
- **GitHub Pages analytics** for subdomains
- **Custom analytics** for grainpbc.com

## 🎯 **Benefits**

### **Cost Optimization**
- **50% cost reduction** from 3-year to 1-year purchases
- **Flexibility** to rebuy grainsix/grain6 domains later
- **Better cash flow** management

### **Brand Strategy**
- **grain12pbc** → Main Grain Network brand
- **grainpbc** → Core platform brand
- **Clear separation** between network and platform

### **Technical Benefits**
- **Custom domains** for better branding
- **SSL certificates** for security
- **Professional appearance** for users

## ⚠️ **Considerations**

### **Domain Renewal**
- **Monitor expiration dates** (1 year from purchase)
- **Set up auto-renewal** if available
- **Budget for renewal costs**

### **Backup Strategy**
- **Keep GitHub Pages URLs** as fallback
- **Document domain dependencies**
- **Plan for domain loss scenarios**

### **Future Purchases**
- **grainsix domains** → Rebuy in 1-2 months
- **grain6 domains** → Rebuy in 1-2 months
- **Additional TLDs** → Consider .io, .dev, .app

## 🔄 **Next Steps**

1. **Cancel grainsix and grain6 domains** for refund
2. **Configure DNS** for grain12pbc and grainpbc domains
3. **Update repository descriptions** with new domains
4. **Set up custom domains** for GitHub Pages
5. **Test domain resolution** and functionality
6. **Update documentation** with new domain strategy

This domain strategy provides cost optimization while maintaining professional branding and technical capabilities.

