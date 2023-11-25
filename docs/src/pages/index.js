import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';

import Heading from '@theme/Heading';
import styles from './index.module.css';

import CreateThreader from "@site/static/img/examples/CreateThreader.png"
import CreateThreadWorker from "@site/static/img/examples/CreateThreadWorker.png"
import GetDataBack from "@site/static/img/examples/GetDataBack.png"

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/Threader">
            Documentation
          </Link>
        </div>
      </div>
    </header>
  );
}



export default function Home() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`Hello from ${siteConfig.title}`}
      description="Description will go into a meta tag in <head />">
      <HomepageHeader />
      <main>
        <HomepageFeatures />

        <header className={clsx('hero', styles.heroBanner)}>
        <div className="container">
          <Heading as="h1">Creating a Threader Class</Heading>
          <div className={styles.showcaseContainer}>
            <img src={CreateThreader} className={styles.showcaseImage}/>
            <h3 className={styles.showcaseTextLeft}>Creating a Threader class is very simple. The first argument is always
            how many threads are there initially and the last one is the ThreadWorker
            itself.</h3>
          </div>
          
          <Heading as="h1">Creating a ThreadWorker</Heading>
          <div className={styles.showcaseContainer}>
            <h3 className={styles.showcaseTextRight}>
              A ThreadWorker is a ModuleScript that is used to process the data in all
              of the threads once Threader:Dispatch() was called.
            </h3>
            <img src={CreateThreadWorker} className={styles.showcaseImage}/>
          </div>
          
          <Heading as="h1">Get the Data Back</Heading>
          <div className={styles.showcaseContainer}>
            <img src={GetDataBack} className={styles.showcaseImage}/>
            <h3 className={styles.showcaseTextLeft}>
              Getting the data back from all of the threads is very simple! Since Threader is
              Promise based after calling Threader:Dispatch() a Promise will be returned
              that will resolve once all of the threads had completed or gets rejected if
              any error occurs!
            </h3>
          </div>
        </div>
        </header>

      </main>
    </Layout>
  );
}
