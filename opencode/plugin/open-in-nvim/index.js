// Opens a file from the current session's "files changed" list in your tmux nvim
// instance via the open-in-nvim shell helper. Bound to <leader>O by default.

const tui = async (api) => {
  const unregister = api.command.register(() => {
    const route = api.route.current;
    if (route?.name !== "session") return [];
    const sessionID = route.params?.sessionID;
    if (!sessionID) return [];

    const diff = api.state.session.diff(sessionID);
    if (!diff || diff.length === 0) return [];

    return [
      {
        title: "Open changed file in nvim",
        value: "open-in-nvim:pick",
        description: `Pick from ${diff.length} changed file${diff.length === 1 ? "" : "s"}`,
        category: "Files",
        keybind: "<leader>O",
        onSelect: () => {
          api.ui.dialog.replace(() =>
            api.ui.DialogSelect({
              title: "Open in nvim",
              placeholder: "Filter changed files…",
              options: diff.map((f) => ({
                title: f.file,
                value: f.file,
                description: `+${f.additions} -${f.deletions}`,
              })),
              onSelect: (opt) => {
                api.ui.dialog.clear();
                spawnOpener(api, String(opt.value));
              },
            }),
          );
        },
      },
    ];
  });

  api.lifecycle.onDispose(unregister);
};

function spawnOpener(api, file) {
  try {
    const proc = Bun.spawn(["open-in-nvim", file], {
      stdin: "ignore",
      stdout: "ignore",
      stderr: "pipe",
    });
    proc.exited.then((code) => {
      if (code !== 0) {
        api.ui.toast({
          variant: "error",
          title: "open-in-nvim failed",
          message: `exit ${code} for ${file}`,
        });
      }
    });
  } catch (err) {
    api.ui.toast({
      variant: "error",
      title: "open-in-nvim not found",
      message: String(err?.message ?? err),
    });
  }
}

export default { id: "open-in-nvim", tui };
