import os, pathlib, subprocess, tempfile, unittest
ROOT = pathlib.Path(__file__).resolve().parents[1]
class Install(unittest.TestCase):
    def test_repeat_preserves_local_files(self):
        with tempfile.TemporaryDirectory() as td:
            home = pathlib.Path(td); bin = home/'bin'; bin.mkdir()
            for name, body in {'bun':'echo fixture-bun', 'claude':'echo claudeclaw', 'launchctl':'exit 90', 'curl':'exit 91'}.items():
                p=bin/name; p.write_text('#!/bin/sh\n'+body+'\n'); p.chmod(0o755)
            env={**os.environ, 'HOME':td, 'PATH':str(bin)+':'+os.environ['PATH']}
            def run(data):
                p=subprocess.run(['bash',str(ROOT/'install.sh')],cwd=ROOT,env=env,input=data,text=True,capture_output=True,timeout=20)
                self.assertEqual(p.returncode,0,p.stdout+p.stderr)
            run('\n\n\nnn')
            target=home/'sprut-agent-kit'/'SOUL.md'; self.assertTrue(target.exists())
            target.write_text('local customization\n')
            config=home/'.claude/claudeclaw/settings.json'; before=config.read_bytes()
            run('\nnn')
            self.assertEqual(target.read_text(),'local customization\n')
            self.assertEqual(config.read_bytes(),before)
if __name__=='__main__': unittest.main()
