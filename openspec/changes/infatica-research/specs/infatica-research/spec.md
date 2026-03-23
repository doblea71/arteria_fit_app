# Infatica Research

## Status: Proposed

## ADDED Requirements

### Requirement: Research Infatica SDK

The system SHALL document research findings about Infatica SDK.

#### Scenario: Research completed
- **WHEN** research phase is complete
- **THEN** document answers to all questions from SPEC-018 REQ-018-1

### Requirement: Check SDK availability

The system SHALL verify if Infatica offers a mobile SDK.

#### Scenario: SDK available
- **WHEN** Infatica offers mobile SDK
- **THEN** document SDK type (Flutter, native, etc.)

#### Scenario: SDK not available
- **WHEN** Infatica does not offer mobile SDK
- **THEN** mark as non-viable and proceed to alternatives

### Requirement: Evaluate RGPD compliance

The system SHALL verify if Infatica SDK complies with RGPD requirements.

#### Scenario: RGPD compliant
- **WHEN** Infatica terms are RGPD compatible
- **THEN** document compliance details

#### Scenario: Not RGPD compliant
- **WHEN** Infatica terms violate RGPD
- **THEN** mark as non-viable

### Requirement: Document API key process

The system SHALL document how to obtain API keys from Infatica.

#### Scenario: API keys process known
- **WHEN** registration and API key process is documented
- **THEN** note the steps required

### Requirement: Research alternatives

The system SHALL evaluate at least 2 alternatives if Infatica is not viable.

#### Scenario: Alternatives found
- **WHEN** alternative SDKs are researched
- **THEN** document findings for Honeygain, PacketStream, TraffMonetizer
