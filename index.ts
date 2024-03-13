import init, {eval_code} from './dist/scripts/scryer/scryer_prolog.js'
// import * as scryer_wasm from './public/scripts/scryer/scryer_prolog_bg.wasm';

type ElmPagesInit = {
    load: (elmLoaded: Promise<App>) => Promise<void>;
    flags: unknown;
};

type App = {
    ports: {
        eval: { subscribe: (_: (_: string) => void) => void };
        scryerResultReceiver: { send: (_: string) => void }
    }
}

const config: ElmPagesInit = {
    load: async function (elmLoaded) {
        const app: App = await elmLoaded;
        app.ports.eval.subscribe(async (code: string) => {
            console.log(`Got code: ${code}`);
            await init('/scripts/scryer/scryer_prolog_bg.wasm');
            const result = eval_code(code);
            console.log(`returning res \n${result}`);
            app.ports.scryerResultReceiver.send(result);
        });
        return;
    },
    flags: function () {
        return "You can decode this in Shared.elm using Json.Decode.string!";
    },
};

export default config;
