# FindIP Shield for Google Tag Manager

The official Google Tag Manager tag template for [FindIP Shield](https://findip.net/docs/shield). It installs the Shield browser SDK and can push visitor risk results to the GTM `dataLayer`.

Shield reports network signals such as VPN, proxy, Tor, relay, hosting, datacenter, and malicious-IP activity without collecting form values.

## Install from the Community Template Gallery

After the template is accepted into the Gallery:

1. Open your web container in Google Tag Manager.
2. Open **Templates** and choose **Search Gallery**.
3. Search for **FindIP Shield** and add the template.
4. Create a FindIP Shield tag and enter your public site key.
5. Choose a privacy mode and trigger the tag on **Initialization – All Pages**.
6. Preview the container, verify the installation, and publish.

## Manual import

Until Gallery publication, download [`template.tpl`](template.tpl), then use **Templates → Tag Templates → New → Import** in Google Tag Manager.

You can also download the current release from:

```text
https://cdn.findip.net/shield/gtm/findip-shield.tpl
```

## Configuration

| Field | Purpose |
| --- | --- |
| Public site key | Identifies the Shield site; starts with `pub_` and is safe to expose. |
| Auto-track | Tracks page views, session activity, and supported forms automatically. |
| Privacy mode | Selects `strict`, `balanced`, or `advanced` collection behavior. |
| Push to dataLayer | Emits `findip_risk_result` after a risk response is received. |

## DataLayer event

When enabled, Shield pushes an event similar to:

```js
{
  event: 'findip_risk_result',
  findip_session_id: 'sess_xxx',
  findip_risk_score: 72,
  findip_risk_level: 'high',
  findip_recommendation: 'challenge',
  findip_is_vpn: true,
  findip_is_proxy: false,
  findip_is_tor: false
}
```

See the [GTM integration reference](https://findip.net/docs/shield/google-tag-manager) for the full contract and consent examples.

## Permissions and external services

The template requests permission to:

- Load the Shield SDK from `https://cdn.findip.net/`.
- Call the SDK's `FindIP.init` method.
- Log SDK loading failures in GTM debug mode.

The SDK sends visitor risk events to `https://shield.findip.net/`. Review [Data Collection](https://findip.net/docs/shield/data-collection), [Privacy Modes](https://findip.net/docs/shield/privacy-modes), and the [FindIP Threat Network](https://findip.net/docs/shield/threat-network) before publishing the tag.

## Support and security

Use [GitHub Issues](https://github.com/findip-net/findip-shield-gtm/issues) for template bugs. Report suspected vulnerabilities privately to [info@findip.net](mailto:info@findip.net).

## License

[Apache License 2.0](LICENSE)

