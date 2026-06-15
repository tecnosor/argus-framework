---
name: dora
description: "DORA (Digital Operational Resilience Act) compliance checklist. Validates ICT risk management, incident reporting, resilience testing, third-party risk, and business continuity. Use for financial entities and ICT service providers in the EU."
license: MIT
compatibility: opencode, cursor, windsurf, cline, generic
metadata:
  audience: reviewer, orchestrator, backend-dev, devops
  phase: review, planning
---

# DORA Compliance Skill

You are executing a **DORA (Digital Operational Resilience Act)** compliance assessment.

**Scope:** This skill applies to financial entities and ICT third-party service providers operating in the EU.
It validates that ICT systems are resilient, secure, and can withstand disruptions.

---

## Applicability

This skill is **required** if the project:
- Is a bank, payment institution, investment firm, insurance company, or crypto-asset service provider
- Provides ICT services to financial entities
- Operates critical or important functions for financial services

This skill is **not required** for pure consumer apps with no financial operations or dependencies.

---

## ICT Risk Management

- [ ] **ICT Risk Management Framework**: Documented framework for identifying, assessing, and managing ICT risks
- [ ] **Asset Inventory**: All ICT assets (hardware, software, data, networks) identified and classified
- [ ] **Risk Assessment**: Regular risk assessments performed and documented
- [ ] **Protective Measures**: Preventive controls implemented (firewalls, IDS/IPS, WAF, endpoint protection)
- [ ] **Detection Mechanisms**: Anomaly detection, monitoring, and alerting in place
- [ ] **Response Procedures**: Incident response plan defined and tested
- [ ] **Recovery Procedures**: Backup and restoration procedures documented and tested
- [ ] **Business Continuity**: BCP covers ICT disruptions and critical functions
- [ ] **Change Management**: Changes to ICT systems are controlled, tested, and authorized

---

## ICT Incident Reporting

- [ ] **Incident Classification Scheme**: Defined criteria for major/significant incidents
- [ ] **Detection and Escalation**: Automated alerting with clear escalation paths
- [ ] **Reporting Timeline**: Process to report major incidents to regulators within deadlines
- [ ] **Root Cause Analysis**: Post-incident reviews performed and documented
- [ ] **Communication Plan**: Internal and external stakeholder notification procedures
- [ ] **Learning Loop**: Incidents feed back into risk management and testing

---

## Resilience Testing

- [ ] **Scenario Testing**: Critical systems tested against realistic failure scenarios
- [ ] **Penetration Testing**: Regular security testing (e.g., TIBER-EU or equivalent)
- [ ] **Failover Testing**: Backup systems and DR sites tested periodically
- [ ] **Load Testing**: Systems tested under expected and peak stress conditions
- [ ] **Chaos Engineering**: Where appropriate, controlled failure injection in non-production
- [ ] **Test Documentation**: All tests documented with results and remediation actions

---

## Third-Party Risk

- [ ] **Vendor Assessment**: ICT third-party providers assessed for risk before onboarding
- [ ] **Contractual Clauses**: DORA compliance requirements included in contracts
- [ ] **Subcontractor Oversight**: Subcontractors monitored for compliance
- [ ] **Ongoing Monitoring**: Continuous monitoring of critical third-party providers
- [ ] **Exit Strategy**: Plan exists for switching providers if needed
- [ ] **Concentration Risk**: Dependency on single providers identified and mitigated

---

## Code-Level Checks

- [ ] Health check endpoints exist for all critical services
- [ ] Circuit breakers implemented for external service calls
- [ ] Retry logic with exponential backoff and dead-letter handling
- [ ] Timeouts configured for all external calls
- [ ] Graceful degradation patterns implemented
- [ ] Critical operations are idempotent
- [ ] Backup and restore scripts tested and documented
- [ ] Audit logs capture ICT incidents and responses

---

## Report Format

```markdown
# DORA Assessment Report

## Scope: [module/feature assessed]
## Date: YYYY-MM-DD

## Applicability: [Applicable / Not Applicable]
[reason]

## Findings

### ICT Risk Management — [🔴|🟡|✅]
[findings]

### ICT Incident Reporting — [🔴|🟡|✅]
[findings]

### Resilience Testing — [🔴|🟡|✅]
[findings]

### Third-Party Risk — [🔴|🟡|✅]
[findings]

### Code-Level Checks — [🔴|🟡|✅]
[findings]

## Summary
- 🔴 Critical: X
- 🟡 Warning: Y
- ✅ Pass: Z
- **Status**: [COMPLIANT | PARTIAL | NON-COMPLIANT]

## Action Items
1. [priority action]
```

---

## Rules

1. **Assess applicability first** — DORA applies only to financial entities and ICT service providers
2. **Focus on resilience, not just security** — DORA is about operational continuity
3. **Evidence-based** — require documentation and test evidence
4. **Third-party risk is critical** — financial services depend heavily on ICT providers
5. **Cross-reference with secure-coder and owasp-top10** for technical controls
