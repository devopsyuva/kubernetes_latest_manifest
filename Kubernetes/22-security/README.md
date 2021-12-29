- CIS Kubernetes Benchmark and CIS Amazon EKS Benchmark
- Introduced kube-bench as an open source tool to assess against CIS Kubernetes Benchmarks

# KubeLinter
- KubeLinter analyzes Kubernetes YAML files and Helm charts and checks them against various best practices, with a focus on production readiness and security.
- KubeLinter runs sensible default checks designed to give you useful information about your Kubernetes YAML files and Helm charts.
- Use it to check early and often for security misconfigurations and DevOps best practices. Some common issues that KubeLinter identifies are running containers as a non-root user, enforcing least privilege, and storing sensitive information only in secrets.
- KubeLinter is configurable, so you can enable and disable checks and create your custom checks, depending on the policies you want to follow within your organization. When a lint check fails, KubeLinter also reports recommendations for resolving any potential issues and returns a non-zero exit code.

### References:
- [kube-bench](https://github.com/aquasecurity/kube-bench)
- [KubeLinter](https://www.civo.com/learn/yaml-best-practices-using-kubelinter#ignoring-a-check and https://docs.kubelinter.io/#/configuring-kubelinter)