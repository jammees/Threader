import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Easy to Use',
    Svg: require('@site/static/img/Easy to Use.svg').default,
    description: (
      <>
        Threader was made to make working with Actors easier and overall
        tie everything together.
      </>
    ),
  },
  {
    title: 'Promise Based',
    Svg: require('@site/static/img/Promise Based.svg').default,
    description: (
      <>
        Threader is Promise based. Promises are a great way to observe different
        threads, handle errors.
      </>
    ),
  },
  {
    title: 'Send Data Get Data',
    Svg: require('@site/static/img/Send Data Get Data.svg').default,
    description: (
      <>
        Once Threader had dispatched the work and all the threads had finished, it will return all of the 
        data that the threads had returned.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
