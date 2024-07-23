# function for starting the ssh-agent and loading identities
start_ssh_agent() {
    # Spawn an ssh agent for a limited time only if none already available
    if [ -z "$SSH_AUTH_SOCK" ] && [ -z "$SSH_AGENT_PID" ] ; then
        # Runs the agent only for the next 5 minutes
        eval "$(ssh-agent -s -t 600)"
    fi

    # Now that we know an ssh-agent is available
    # we can register our ssh key with an expiration timeout
    # so the authentication does not remain exposed for too long
    ssh-add -t 600 # expire in 5 minutes
    ssh-add -t 600 ~/.ssh/github_id_ed25519 # expire in 5 minutes
}

# function for stopping the ssh-agent and unloading all identities
kill_ssh_agent() {
    # Remove all identities from the ssh agent and kill the agent if it's running
    if [ ! -z "$SSH_AUTH_SOCK" ] && [ ! -z "$SSH_AGENT_PID" ] ; then
        # Delete all identities from the agent
        ssh-add -D
        
        # Kill the running ssh agent
        eval "$(ssh-agent -k)"
    else
        echo "ssh-agent is not running"
    fi
}

