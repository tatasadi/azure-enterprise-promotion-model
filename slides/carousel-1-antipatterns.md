---
theme: default
background: 'linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%)'
class: 'text-center'
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
title: '12 Azure CI/CD Anti-Patterns'
mdc: true
download: true
exportFilename: 'azure-cicd-antipatterns'
canvasWidth: 1080
aspectRatio: '1/1'
fonts:
  sans: 'Inter, system-ui, -apple-system'
  mono: 'JetBrains Mono, Fira Code'
themeConfig:
  primary: '#0078D4'
colorSchema: 'light'
---

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800;900&display=swap');
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600&display=swap');
</style>

<div class="cover-slide">
  <div class="cover-badge">AZURE CI/CD</div>
  <h1 class="cover-title">12 Anti-Patterns<br/>That Kill Your<br/>Deployments</h1>
  <div class="cover-subtitle">(And How to Fix Them)</div>
  <div class="cover-cta">
    <span class="arrow">→</span> Swipe to learn what NOT to do
  </div>
  <div class="cover-author">Ehsan • Azure Platform Engineer</div>
</div>

---
layout: default
---

<div class="modern-slide">
  <div class="slide-number">01/09</div>
  <h1 class="slide-title">The Reality Check</h1>

  <div class="content-box">
    <p class="lead-text">Most teams learn Azure CI/CD by trial and error.</p>
    <div class="problem-list">
      <div class="problem-item">
        <span class="icon">🚨</span>
        <div>
          <strong>Hardcoded secrets</strong>
          <span class="subtle">everywhere</span>
        </div>
      </div>
      <div class="problem-item">
        <span class="icon">🚨</span>
        <div>
          <strong>Manual infrastructure</strong>
          <span class="subtle">setup</span>
        </div>
      </div>
      <div class="problem-item">
        <span class="icon">🚨</span>
        <div>
          <strong>Direct-to-production</strong>
          <span class="subtle">deploys</span>
        </div>
      </div>
      <div class="problem-item">
        <span class="icon">🚨</span>
        <div>
          <strong>No approval</strong>
          <span class="subtle">process</span>
        </div>
      </div>
      <div class="problem-item">
        <span class="icon">🚨</span>
        <div>
          <strong>Rebuilding</strong>
          <span class="subtle">for each environment</span>
        </div>
      </div>
    </div>
    <div class="warning-box">
      <p>These anti-patterns are common because they're the "easy" way.</p>
      <p class="highlight">But easy now = expensive later.</p>
    </div>
  </div>
</div>

---
layout: default
---

<div class="modern-slide split-slide">
  <div class="slide-number">02/09</div>
  <h1 class="slide-title">Anti-Patterns #1-3: Secret Management</h1>

  <div class="split-container">
    <div class="left-column danger-zone">
      <h3 class="column-title danger">❌ Wrong Way</h3>
      <div class="card danger-card">
        <div class="card-number">#1</div>
        <h4>Hardcoded Secrets</h4>
        <div class="code-snippet">"Password=Admin123!"</div>
        <p class="consequence">→ One git commit = exposed</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#2</div>
        <h4>Pipeline Variables</h4>
        <p>Storing credentials in Azure DevOps</p>
        <p class="consequence">→ Not designed for secrets</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#3</div>
        <h4>Secrets in Config</h4>
        <p>Committed appsettings.json</p>
        <p class="consequence">→ Visible in every PR</p>
      </div>
    </div>
    <div class="right-column success-zone">
      <h3 class="column-title success">✅ Right Way</h3>
      <div class="card success-card">
        <div class="icon-large">🔐</div>
        <h4>Azure Key Vault</h4>
        <p>Centralized secret storage</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">🆔</div>
        <h4>Managed Identity</h4>
        <p>No passwords needed!</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">🔒</div>
        <h4>RBAC</h4>
        <p>Proper access control</p>
      </div>
    </div>
  </div>
</div>

---
layout: default
---

<div class="modern-slide split-slide">
  <div class="slide-number">03/09</div>
  <h1 class="slide-title">Anti-Patterns #4-6: Infrastructure Chaos</h1>

  <div class="split-container">
    <div class="left-column danger-zone">
      <h3 class="column-title danger">❌ Wrong Way</h3>
      <div class="card danger-card">
        <div class="card-number">#4</div>
        <h4>Manual Creation</h4>
        <p>Clicking through Azure Portal</p>
        <p class="consequence">→ Can't reproduce</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#5</div>
        <h4>"Pet" Infrastructure</h4>
        <p>"Don't touch prod, it works!"</p>
        <p class="consequence">→ Afraid to change</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#6</div>
        <h4>No State Tracking</h4>
        <p>Changes happen randomly</p>
        <p class="consequence">→ Configuration drift</p>
      </div>
    </div>
    <div class="right-column success-zone">
      <h3 class="column-title success">✅ Right Way</h3>
      <div class="card success-card">
        <div class="icon-large">🏗️</div>
        <h4>Infrastructure as Code</h4>
        <p>Terraform or Bicep</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">📝</div>
        <h4>Version Control</h4>
        <p>Track all changes</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">💾</div>
        <h4>Remote State</h4>
        <p>Prevent drift</p>
      </div>
    </div>
  </div>
</div>

---
layout: default
---

<div class="modern-slide split-slide">
  <div class="slide-number">04/09</div>
  <h1 class="slide-title">Anti-Patterns #7-9: Deployment Disasters</h1>

  <div class="split-container">
    <div class="left-column danger-zone">
      <h3 class="column-title danger">❌ Wrong Way</h3>
      <div class="card danger-card">
        <div class="card-number">#7</div>
        <h4>No Test Environment</h4>
        <p>"We'll test in production!"</p>
        <p class="consequence">→ Users find bugs</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#8</div>
        <h4>Rebuild Per Environment</h4>
        <p>Different binaries each time</p>
        <p class="consequence">→ Different behavior</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#9</div>
        <h4>No Approval Gates</h4>
        <p>Direct path to production</p>
        <p class="consequence">→ No safety net</p>
      </div>
    </div>
    <div class="right-column success-zone">
      <h3 class="column-title success">✅ Right Way</h3>
      <div class="card success-card">
        <div class="icon-large">🔄</div>
        <h4>Multi-Environment</h4>
        <p>Dev → Test → Prod</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">📦</div>
        <h4>Build Once</h4>
        <p>Deploy everywhere</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">✋</div>
        <h4>Approval Gates</h4>
        <p>Control production access</p>
      </div>
    </div>
  </div>
</div>

---
layout: default
---

<div class="modern-slide split-slide">
  <div class="slide-number">05/09</div>
  <h1 class="slide-title">Anti-Patterns #10-12: Pipeline Problems</h1>

  <div class="split-container">
    <div class="left-column danger-zone">
      <h3 class="column-title danger">❌ Wrong Way</h3>
      <div class="card danger-card">
        <div class="card-number">#10</div>
        <h4>Monolithic YAML</h4>
        <p>1000+ line single file</p>
        <p class="consequence">→ Hard to maintain</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#11</div>
        <h4>No Health Checks</h4>
        <p>"Did it deploy? 🤷"</p>
        <p class="consequence">→ Silent failures</p>
      </div>
      <div class="card danger-card">
        <div class="card-number">#12</div>
        <h4>No Rollback Plan</h4>
        <p>"Just push a fix!"</p>
        <p class="consequence">→ Extended downtime</p>
      </div>
    </div>
    <div class="right-column success-zone">
      <h3 class="column-title success">✅ Right Way</h3>
      <div class="card success-card">
        <div class="icon-large">🧩</div>
        <h4>Modular Templates</h4>
        <p>Reusable components</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">✅</div>
        <h4>Health Checks</h4>
        <p>Automated validation</p>
      </div>
      <div class="card success-card">
        <div class="icon-large">⏮️</div>
        <h4>Versioned Artifacts</h4>
        <p>Easy rollback</p>
      </div>
    </div>
  </div>
</div>

---
layout: default
---

<div class="modern-slide">
  <div class="slide-number">06/09</div>
  <h1 class="slide-title">The Enterprise Pattern</h1>
  <p class="subtitle">Build Once, Deploy Everywhere</p>

  <div class="pipeline-visual">
    <div class="pipeline-stage build">
      <div class="stage-icon">🏗️</div>
      <div class="stage-name">BUILD</div>
      <div class="stage-desc">One artifact</div>
    </div>
    <div class="pipeline-arrow">→</div>
    <div class="pipeline-stage dev">
      <div class="stage-icon">🧪</div>
      <div class="stage-name">DEV</div>
      <div class="stage-desc">Automatic</div>
      <div class="stage-badge auto">AUTO</div>
    </div>
    <div class="pipeline-arrow">→</div>
    <div class="pipeline-stage test">
      <div class="stage-icon">🔍</div>
      <div class="stage-name">TEST</div>
      <div class="stage-desc">QA validation</div>
      <div class="stage-badge approval">APPROVAL</div>
    </div>
    <div class="pipeline-arrow">→</div>
    <div class="pipeline-stage prod">
      <div class="stage-icon">🚀</div>
      <div class="stage-name">PROD</div>
      <div class="stage-desc">Controlled release</div>
      <div class="stage-badge approval">APPROVAL</div>
    </div>
  </div>
  <div class="feature-grid">
    <div class="feature-item">
      <span class="feature-icon">🔐</span>
      <span>Key Vault</span>
    </div>
    <div class="feature-item">
      <span class="feature-icon">🆔</span>
      <span>Managed Identity</span>
    </div>
    <div class="feature-item">
      <span class="feature-icon">🏗️</span>
      <span>IaC</span>
    </div>
    <div class="feature-item">
      <span class="feature-icon">✅</span>
      <span>Health Checks</span>
    </div>
  </div>

  <div class="highlight-box">
    Same code, same behavior.
  </div>
</div>

---
layout: default
---

<div class="modern-slide">
  <div class="slide-number">07/09</div>
  <h1 class="slide-title">Why This Matters</h1>

  <div class="impact-grid">
    <div class="impact-card security">
      <div class="impact-icon">💰</div>
      <h3>Security Risks</h3>
      <ul>
        <li>Exposed credentials</li>
        <li>Failed security audits</li>
        <li>Compliance violations</li>
      </ul>
    </div>
    <div class="impact-card time">
      <div class="impact-icon">⏱️</div>
      <h3>Wasted Time</h3>
      <ul>
        <li>"Works on my machine"</li>
        <li>Manual deployments</li>
        <li>Production firefighting</li>
      </ul>
    </div>
    <div class="impact-card business">
      <div class="impact-icon">📉</div>
      <h3>Business Impact</h3>
      <ul>
        <li>Deployment anxiety</li>
        <li>Slower delivery</li>
        <li>Team burnout</li>
      </ul>
    </div>
  </div>
  <div class="stats-box">
    <p class="stats-title">Microsoft's research shows:</p>
    <p class="stats-highlight">Elite teams deploy <strong>200x more frequently</strong></p>
    <p class="stats-highlight">with <strong>3x lower failure rates</strong></p>
    <p class="stats-footer">The difference? They avoid these anti-patterns.</p>
  </div>
</div>

---
layout: default
---

<div class="modern-slide">
  <div class="slide-number">08/09</div>
  <h1 class="slide-title">How to Fix This</h1>

  <div class="roadmap">
    <div class="roadmap-phase">
      <div class="phase-header phase-1">
        <span class="phase-number">1</span>
        <span class="phase-title">Security First</span>
      </div>
      <div class="phase-steps">
        <div class="step">1️⃣ Set up Azure Key Vault</div>
        <div class="step">2️⃣ Enable Managed Identity</div>
        <div class="step">3️⃣ Remove hardcoded secrets</div>
      </div>
    </div>
    <div class="roadmap-phase">
      <div class="phase-header phase-2">
        <span class="phase-number">2</span>
        <span class="phase-title">Infrastructure</span>
      </div>
      <div class="phase-steps">
        <div class="step">4️⃣ Choose IaC (Terraform/Bicep)</div>
        <div class="step">5️⃣ Create reusable modules</div>
        <div class="step">6️⃣ Set up remote state</div>
      </div>
    </div>
    <div class="roadmap-phase">
      <div class="phase-header phase-3">
        <span class="phase-number">3</span>
        <span class="phase-title">Pipeline</span>
      </div>
      <div class="phase-steps">
        <div class="step">7️⃣ Create dev/test/prod envs</div>
        <div class="step">8️⃣ Implement artifact promotion</div>
        <div class="step">9️⃣ Add approval gates</div>
      </div>
    </div>
    <div class="roadmap-phase">
      <div class="phase-header phase-4">
        <span class="phase-number">4</span>
        <span class="phase-title">Quality</span>
      </div>
      <div class="phase-steps">
        <div class="step">🔟 Modularize templates</div>
        <div class="step">1️⃣1️⃣ Add health checks</div>
        <div class="step">1️⃣2️⃣ Enable rollback capability</div>
      </div>
    </div>
  </div>

  <div class="cta-box">
    Start small. Improve incrementally.
  </div>
</div>

---
layout: default
---

<div class="modern-slide final-slide">
  <div class="slide-number">09/09</div>
  <h1 class="slide-title">Key Takeaways</h1>

  <div class="takeaways">
    <div class="takeaway-item">
      <span class="check">✅</span>
      <div>
        <strong>These anti-patterns are common</strong>
        <span class="note">(You're not alone!)</span>
      </div>
    </div>
    <div class="takeaway-item">
      <span class="check">✅</span>
      <div>
        <strong>Fix security first</strong>
        <span class="note">(Secrets, identity, access control)</span>
      </div>
    </div>
    <div class="takeaway-item">
      <span class="check">✅</span>
      <div>
        <strong>Infrastructure as Code is essential</strong>
        <span class="note">(Terraform or Bicep)</span>
      </div>
    </div>
    <div class="takeaway-item">
      <span class="check">✅</span>
      <div>
        <strong>Build once, promote everywhere</strong>
        <span class="note">(Consistency matters)</span>
      </div>
    </div>
    <div class="takeaway-item">
      <span class="check">✅</span>
      <div>
        <strong>Multiple environments protect you</strong>
        <span class="note">(Test before production)</span>
      </div>
    </div>
  </div>

  <div class="final-message">
    <p>Azure DevOps is powerful—</p>
    <p class="emphasis">but only if you use it right.</p>
  </div>
</div>

---
layout: default
---

<div class="modern-slide cta-slide">
  <div class="slide-number">10/10</div>

  <div class="author-section">
    <img src="/Ehsan.jpg" alt="Ehsan Tatasadi" class="author-avatar" />
    <h2 class="author-name">Ehsan Tatasadi</h2>
    <p class="author-title">Senior Azure Engineer (Platform & DevOps)</p>
  </div>

  <div class="final-cta">
    💬 Which one surprised you most?<br/>
    Let me know in the comments!
  </div>

  <div class="follow-cta">
    👉 Follow for more Azure tips
  </div>

  <div class="hashtags">
    #Azure #DevOps #CloudEngineering
  </div>
</div>
