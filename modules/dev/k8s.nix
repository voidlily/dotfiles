{
  ...
}:

{
  den.aspects.k8s = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.minikube ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          argocd
          argo-rollouts
          kubectl
          kubectl-neat
          kubernetes-helm
          kubelogin-oidc
          kubeseal
          kubeswitch
          kustomize
          nova
          pluto
          popeye
        ];
        programs.k9s = {
          enable = true;
          settings = {
            k9s = {
              ui = {
                skin = "solarized-dark";
              };
            };
          };

          skins = {
            solarized-dark = "${pkgs.k9s}/share/k9s/skins/solarized-dark.yaml";
          };

          plugins = {
            # https://github.com/derailed/k9s/blob/master/plugins/argo-rollouts.yaml
            argo-rollouts-get = {
              shortCut = "g";
              confirm = false;
              description = "Get details";
              scopes = [ "rollouts" ];
              command = "bash";
              background = false;
              args = [
                "-c"
                "kubectl argo rollouts get rollout $NAME --context $CONTEXT -n $NAMESPACE |& less"
              ];
            };
            argo-rollouts-watch = {
              shortCut = "w";
              confirm = false;
              description = "Watch progress";
              scopes = [ "rollouts" ];
              command = "bash";
              background = false;
              args = [
                "-c"
                "kubectl argo rollouts get rollout $NAME --context $CONTEXT -n $NAMESPACE -w |& less"
              ];
            };
            argo-rollouts-promote = {
              shortCut = "p";
              confirm = true;
              description = "Promote";
              scopes = [ "rollouts" ];
              command = "bash";
              background = false;
              args = [
                "-c"
                "kubectl argo rollouts promote $NAME --context $CONTEXT -n $NAMESPACE |& less"
              ];
            };
            argo-rollouts-restart = {
              shortCut = "r";
              confirm = true;
              description = "Restart";
              scopes = [ "rollouts" ];
              command = "bash";
              background = false;
              args = [
                "-c"
                "kubectl argo rollouts restart $NAME --context $CONTEXT -n $NAMESPACE |& less"
              ];
            };
            krr = {
              shortCut = "Shift-K";
              confirm = false;
              description = "Get krr";
              scopes = [
                "deployments"
                "statefulsets"
                "daemonsets"
                "rollouts"
              ];
              command = "bash";
              background = false;
              args = [
                "-c"
                ''
                  LABELS=$(kubectl get $RESOURCE_NAME $NAME -n $NAMESPACE  --context $CONTEXT  --show-labels | awk '{print $NF}' | awk '{if(NR>1)print}')
                  krr simple --cluster $CONTEXT --selector $LABELS
                  echo "Press 'q' to exit"
                  while : ; do
                  read -n 1 k <&1
                  if [[ $k = q ]] ; then
                  break
                  fi
                  done
                ''
              ];
            };
            raw-logs-follow = {
              shortCut = "Ctrl-L";
              description = "logs -f";
              scopes = [
                "po"
              ];
              command = "kubectl";
              background = false;
              args = [
                "logs"
                "-f"
                "$NAME"
                "-n"
                "$NAMESPACE"
                "--context"
                "$CONTEXT"
              ];
            };
            log-less = {
              shortCut = "Shift-L";
              description = "logs|less";
              scopes = [
                "po"
              ];
              command = "bash";
              background = false;
              args = [
                "-c"
                "\"$@\" | less"
                "dummy-arg"
                "kubectl"
                "logs"
                "$NAME"
                "-n"
                "$NAMESPACE"
                "--context"
                "$CONTEXT"
              ];
            };
          };
        };

      };
  };
}
