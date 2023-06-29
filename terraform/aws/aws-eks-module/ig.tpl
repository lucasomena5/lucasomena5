apiVersion: v1
kind: Namespace
metadata:
  name: fr-ig
---
apiVersion: v1
data: {}
kind: Secret
metadata:
  labels:
    app: ig
    app.kubernetes.io/component: ig
    app.kubernetes.io/instance: ig
    app.kubernetes.io/name: ig
    app.kubernetes.io/part-of: forgerock
    tier: middle
  name: openig-secrets-env
  namespace: fr-ig
type: Opaque
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ig
    app.kubernetes.io/component: ig
    app.kubernetes.io/instance: ig
    app.kubernetes.io/name: ig
    app.kubernetes.io/part-of: forgerock
    tier: middle
  name: ig
  namespace: fr-ig
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ig
      app.kubernetes.io/component: ig
      app.kubernetes.io/instance: ig
      app.kubernetes.io/name: ig
      app.kubernetes.io/part-of: forgerock
      tier: middle
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
      creationTimestamp: null
      labels:
        app: ig
        app.kubernetes.io/component: ig
        app.kubernetes.io/instance: ig
        app.kubernetes.io/name: ig
        app.kubernetes.io/part-of: forgerock
        tier: middle
    spec:
      volumes:
      - name: ig-storage
        emptyDir: {}
      containers:
      - env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        envFrom:
        - secretRef:
            name: openig-secrets-env
        image: ${IMAGE_ID}
        volumeMounts:
        - name: ig-storage
          mountPath: /data/ig
        imagePullPolicy: Always
        livenessProbe:
          httpGet:
            host:
            scheme: HTTP
            path: /
            port: 8080
            httpHeaders:
            - name: Host
              value: status.podIP
          initialDelaySeconds: 5
          periodSeconds: 5
          successThreshold: 1
          timeoutSeconds: 1
          failureThreshold: 1
        name: ig
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
        ports:
        - containerPort: 8080
          protocol: TCP
        readinessProbe:
          httpGet:
            host:
            scheme: HTTP
            path: /
            port: 8080
            httpHeaders:
            - name: Host
              value: status.podIP
          failureThreshold: 1
          initialDelaySeconds: 5
          periodSeconds: 10
        resources:
          requests:
            cpu: 200m
            memory: 512Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        runAsGroup: 0
        runAsUser: 11111
      terminationGracePeriodSeconds: 30
      hostNetwork: true
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: ig
    app.kubernetes.io/component: ig
    app.kubernetes.io/instance: ig
    app.kubernetes.io/name: ig
    app.kubernetes.io/part-of: forgerock
    tier: middle
  name: ig
  namespace: fr-ig
spec:
  ipFamilies:
  - IPv6
  ipFamilyPolicy: PreferDualStack
  ports:
  - name: ig
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: ig
    app.kubernetes.io/component: ig
    app.kubernetes.io/instance: ig
    app.kubernetes.io/name: ig
    app.kubernetes.io/part-of: forgerock
    tier: middle
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    # LOAD BALANCER
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/ip-address-type: dualstack
    alb.ingress.kubernetes.io/load-balancer-name: ig-alb
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 8080}, {"HTTP": 80}, {"HTTPS": 443}, {"HTTPS": 8443}]' #'[{"HTTP": 8080}]'
    alb.ingress.kubernetes.io/tags: Purpose=lab
    alb.ingress.kubernetes.io/group.name: ig-group
    alb.ingress.kubernetes.io/certificate-arn: "${ACM_CERTIFICATE_ARN}"
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-1-2017-01
    #alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=60
    #alb.ingress.kubernetes.io/security-groups:
    #alb.ingress.kubernetes.io/subnets: subnet-12345, subnet-54321
    #alb.ingress.kubernetes.io/load-balancer-attributes: routing.http2.enabled=true
    # HEALTH CHECK
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '8'
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '30'
    alb.ingress.kubernetes.io/healthcheck-path: /
    alb.ingress.kubernetes.io/healthcheck-port: '8080'
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    alb.ingress.kubernetes.io/success-codes: '200'
  name: ig
  namespace: fr-ig
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ig
                port:
                  number: 8080
---
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: ig
  namespace: fr-ig
spec:
  maxReplicas: 4
  minReplicas: 2
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ig
  targetCPUUtilizationPercentage: 70