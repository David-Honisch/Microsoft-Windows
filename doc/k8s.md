 # K8s/RHOS

Die wichtigsten Kubernetes-Befehle werden über das Kommandozeilentool
kubectl ausgeführt. Sie lassen sich in Kategorien wie Ressourcenabfrage, Fehlersuche und Cluster-Verwaltung unterteilen.

## 1. Ressourcen anzeigen und abfragen (get)
Diese Befehle liefern einen Überblick über den aktuellen Zustand Ihrer Objekte.

    kubectl get pods: Listet alle Pods im aktuellen Namespace auf.
    kubectl get pods -A: Zeigt alle Pods über alle Namespaces hinweg an.
    kubectl get nodes: Listet alle Knoten (Server) im Cluster und deren Status auf.
    kubectl get svc: Zeigt alle Services und deren (interne/externe) IP-Adressen an.
    kubectl get all: Gibt eine Zusammenfassung fast aller Ressourcen im aktuellen Namespace aus.

## 2. Fehlersuche und Analyse (describe, logs, exec)
Wenn etwas nicht funktioniert, helfen diese Befehle bei der Ursachenforschung.

    kubectl describe pod <pod-name>: Liefert detaillierte Informationen und Events (Fehlermeldungen) zu einem spezifischen Pod.
    kubectl logs <pod-name>: Zeigt die Standardausgabe (Logs) der Container in einem Pod an. Nutzen Sie -f für Live-Streaming.
    kubectl exec -it <pod-name> -- /bin/bash: Öffnet ein interaktives Terminal direkt im Container.
    kubectl top nodes/pods: Zeigt die aktuelle CPU- und Speicherauslastung an (erfordert den Metrics-Server).

## 3. Ressourcen erstellen und ändern (apply, scale, edit)

    kubectl apply -f <dateiname.yaml>: Erstellt oder aktualisiert Ressourcen basierend auf einer Konfigurationsdatei (deklarativer Ansatz).
    kubectl scale deployment <name> --replicas=3: Ändert die Anzahl der laufenden Instanzen (Pods) einer Anwendung.
    kubectl edit <ressource> <name>: Öffnet die Live-Konfiguration direkt in einem Texteditor zur schnellen Bearbeitung.

## 4. Cluster-Konfiguration und Wartung

    kubectl cluster-info: Zeigt die Endpunkte der Control-Plane und installierten Dienste an.
    kubectl config get-contexts: Listet alle verfügbaren Cluster-Verbindungen (Kontexte) auf.
    kubectl config use-context <name>: Wechselt zwischen verschiedenen Kubernetes-Clustern.
    kubectl drain <node-name>: Bereitet einen Knoten auf Wartungsarbeiten vor, indem alle Pods sicher entfernt werden.

### Tipps für effizientes Arbeiten

    Alias setzen: Verwenden Sie alias k='kubectl', um Tipparbeit zu sparen.
    Namespaces: Viele Befehle benötigen den Zusatz -n <namespace>, wenn Sie nicht im default-Namespace arbeiten.
    Ausgabeformat: Mit -o wide erhalten Sie zusätzliche Spalten (wie Node-IPs), mit -o yaml die vollständige Ressourcen-Definition.
